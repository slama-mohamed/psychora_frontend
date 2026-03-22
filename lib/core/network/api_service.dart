import 'dart:developer' as developer;

import 'package:dio/dio.dart';

import 'interceptors/auth_interceptor.dart';
import 'interceptors/unauthorized_interceptor.dart';
import 'network_config.dart';
import 'token_store.dart';

class ApiService {
  ApiService._internal()
      : _dio = Dio(
          BaseOptions(
            baseUrl: NetworkConfig.baseUrl,
            connectTimeout: NetworkConfig.connectTimeout,
            receiveTimeout: NetworkConfig.receiveTimeout,
            sendTimeout: NetworkConfig.sendTimeout,
            headers: <String, dynamic>{
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    _setupInterceptors();
  }

  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  final Dio _dio;
  final TokenStore _tokenStore = TokenStore();

  UnauthorizedCallback? _onUnauthorized;

  Dio get dio => _dio;

  void setAuthToken(String token) {
    _tokenStore.saveToken(token);
  }

  void clearAuthToken() {
    _tokenStore.clearToken();
  }

  String? get currentToken => _tokenStore.accessToken;

  void setUnauthorizedHandler(UnauthorizedCallback callback) {
    _onUnauthorized = callback;
  }

  void _setupInterceptors() {
    _dio.interceptors
      ..clear()
      ..add(AuthInterceptor(tokenProvider: _tokenStore.readToken))
      ..add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          logPrint: (Object object) {
            developer.log(object.toString(), name: 'ApiService');
          },
        ),
      )
      ..add(
        UnauthorizedInterceptor(
          onUnauthorized: (DioException error) {
            _tokenStore.clearToken();
            _onUnauthorized?.call(error);
          },
        ),
      );
  }
}
