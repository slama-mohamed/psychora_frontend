import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:psychora/core/constants/end_point_url.dart';

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

  Future<Response<dynamic>> loginUser({
    required String email,
    required String password,
    String path = EndPointUrl.login,
  }) async {
    final response = await _dio.post<dynamic>(
      path,
      data: <String, dynamic>{
        'email': email,
        'password': password,
      },
    );

    final dynamic responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      final String? token = (responseData['accessToken'] as String?) ??
          (responseData['token'] as String?);

      if (token != null && token.isNotEmpty) {
        setAuthToken(token);
      }
    }

    return response;
  }

  Future<Response<dynamic>> signupPsychologist({
    required String fullName,
    required String email,
    required String password,
    required String specialty,
    required String idCard,
    required String hospital,
    required String location,
    required String phone,
    required int yearsOfExperience,
    String path = EndPointUrl.signup,
  }) async {
    final response = await _dio.post<dynamic>(
      path,
      data: <String, dynamic>{
        'fullName': fullName,
        'email': email,
        'password': password,
        'role': 'Doctor',
        'specialty': specialty,
        'idCard': idCard,
        'hospital': hospital,
        'location': location,
        'phone': phone,
        'yearsOfExperience': yearsOfExperience,
      },
    );

    final dynamic responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      final String? token = (responseData['accessToken'] as String?) ??
          (responseData['token'] as String?);

      if (token != null && token.isNotEmpty) {
        setAuthToken(token);
      }
    }

    return response;
  }

  Future<Response<dynamic>> resetPassword({
    required String newPassword,
    required String confirmPassword,
    String? email,
    String? token,
    String path = EndPointUrl.resetPassword,
  }) async {
    final Map<String, dynamic> data = <String, dynamic>{
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };

    if (email != null && email.isNotEmpty) {
      data['email'] = email;
    }

    if (token != null && token.isNotEmpty) {
      data['token'] = token;
    }

    return _dio.post<dynamic>(
      path,
      data: data,
    );
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
