class NetworkConfig {
  NetworkConfig._();

  // Update with your backend base URL.
  static const String baseUrl = '';

  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 20);
  static const Duration sendTimeout = Duration(seconds: 20);
}
