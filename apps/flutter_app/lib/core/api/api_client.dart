import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/secure_storage.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'http://localhost:3000',
      ),
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Add interceptor for authentication
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final storage = ref.read(secureStorageProvider);
        final token = await storage.getAccessToken();
        
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // Token expired, try to refresh
          final storage = ref.read(secureStorageProvider);
          final refreshToken = await storage.getRefreshToken();
          
          if (refreshToken != null) {
            try {
              final response = await dio.post(
                '/auth/refresh',
                data: {'refreshToken': refreshToken},
              );
              
              final newAccessToken = response.data['accessToken'];
              await storage.saveAccessToken(newAccessToken);
              
              // Retry the original request
              error.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
              final retryResponse = await dio.fetch(error.requestOptions);
              return handler.resolve(retryResponse);
            } catch (e) {
              // Refresh failed, logout
              await storage.clearTokens();
              return handler.next(error);
            }
          }
        }
        
        return handler.next(error);
      },
    ),
  );

  return dio;
});

