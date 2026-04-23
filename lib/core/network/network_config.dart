class NetworkConfig {
  NetworkConfig._();

  // Update with your backend base URL.
  static const String baseUrl = 'https://trichitic-overfrailly-sonny.ngrok-free.dev';

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 120);
  static const Duration sendTimeout = Duration(seconds: 30);
}
