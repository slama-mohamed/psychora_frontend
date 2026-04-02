class TokenStore {
  String? _accessToken;

  String? get accessToken => _accessToken;

  Future<String?> readToken() async => _accessToken;

  void saveToken(String token) {
    _accessToken = token;
  }

  void clearToken() {
    _accessToken = null;
  }
}
