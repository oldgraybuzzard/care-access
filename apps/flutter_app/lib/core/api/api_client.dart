import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../config/app_config.dart';
import '../storage/secure_storage.dart';

final dioProvider = Provider<Dio>((ref) {
  final config = AppConfig.current;
  final logger = Logger();

  if (config.enableLogging) {
    logger.i('🌐 API Client initialized');
    logger.i('📍 Environment: ${config.environment}');
    logger.i('🔗 Base URL: ${config.apiBaseUrl}');
  }

  final dio = Dio(
    BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: config.connectTimeout,
      receiveTimeout: config.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Add logging interceptor (only in development)
  if (config.enableLogging) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          logger.d('🚀 ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          logger.d('✅ ${response.statusCode} ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (error, handler) {
          logger.e(
            '❌ ${error.response?.statusCode} ${error.requestOptions.path}',
          );
          logger.e('💥 Error: ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

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
              error.requestOptions.headers['Authorization'] =
                  'Bearer $newAccessToken';
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
