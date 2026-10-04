enum AppEnvironment { development, staging, production }

abstract final class AppEnvironmentConfig {
  static const String _value = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'development',
  );

  static AppEnvironment get current => switch (_value) {
        'production' => AppEnvironment.production,
        'staging' => AppEnvironment.staging,
        _ => AppEnvironment.development,
      };

  static bool get isProduction => current == AppEnvironment.production;
}
