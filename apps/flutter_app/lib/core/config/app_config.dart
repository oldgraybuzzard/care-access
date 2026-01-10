/// Application configuration for different environments
class AppConfig {
  final String apiBaseUrl;
  final String environment;
  final bool enableLogging;
  final Duration connectTimeout;
  final Duration receiveTimeout;

  const AppConfig({
    required this.apiBaseUrl,
    required this.environment,
    this.enableLogging = true,
    this.connectTimeout = const Duration(seconds: 30),
    this.receiveTimeout = const Duration(seconds: 30),
  });

  /// Development configuration (local API)
  static const development = AppConfig(
    apiBaseUrl: 'http://localhost:3000',
    environment: 'development',
    enableLogging: true,
  );

  /// Production configuration (Railway deployment)
  static const production = AppConfig(
    apiBaseUrl: 'https://fcfapi-production.up.railway.app',
    environment: 'production',
    enableLogging: false,
  );

  /// Get current configuration based on environment variable
  /// Falls back to development if not specified
  static AppConfig get current {
    const env = String.fromEnvironment(
      'ENVIRONMENT',
      defaultValue: 'development',
    );

    // Allow override via API_BASE_URL environment variable
    const customApiUrl = String.fromEnvironment('API_BASE_URL');

    if (customApiUrl.isNotEmpty) {
      return const AppConfig(
        apiBaseUrl: customApiUrl,
        environment: env,
        enableLogging: env == 'development',
      );
    }

    switch (env) {
      case 'production':
        return production;
      case 'development':
      default:
        return development;
    }
  }

  /// Check if running in production
  bool get isProduction => environment == 'production';

  /// Check if running in development
  bool get isDevelopment => environment == 'development';

  @override
  String toString() {
    return 'AppConfig(environment: $environment, apiBaseUrl: $apiBaseUrl)';
  }
}
