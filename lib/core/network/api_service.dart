import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:psychora/core/constants/end_point_url.dart';
import 'package:psychora/features/patient_dashboard/data/patientmodel.dart';

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

  Future<Response<dynamic>> requestPasswordResetLink({
    required String email,
    String path = EndPointUrl.forgotPassword,
  }) async {
    return _dio.post<dynamic>(
      path,
      data: <String, dynamic>{
        'email': email,
      },
    );
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

  Future<Response<dynamic>> addPatient({
    required String name,
    required int age,
    required String condition,
    required String lastSeen,
    required int sessionsCount,
    String path = EndPointUrl.addPatient,
  }) async {
    final Map<String, dynamic> data = <String, dynamic>{
      'name': name,
      'age': age,
      'condition': condition,
      'lastSeen': lastSeen,
      'sessionsCount': sessionsCount,
    };

    return _dio.post<dynamic>(
      path,
      data: data,
    );
  }

  Future<List<PatientModel>> getPatients({
    String path = EndPointUrl.addPatient,
  }) async {
    final Response<dynamic> response = await _dio.get<dynamic>(path);
    final List<Map<String, dynamic>> rows = _extractPatientRows(response.data);

    return rows
        .map((Map<String, dynamic> row) => PatientModel.fromMap(row))
        .where((PatientModel patient) {
          return patient.id.isNotEmpty || patient.name.isNotEmpty;
        })
        .toList();
  }

  Future<Response<dynamic>> updatePatient({
    required String patientId,
    required String name,
    required int age,
    required String condition,
    required String lastSeen,
    required int sessionsCount,
    String path = EndPointUrl.addPatient,
  }) async {
    final Map<String, dynamic> data = <String, dynamic>{
      'name': name,
      'age': age,
      'condition': condition,
      'lastSeen': lastSeen,
      'sessionsCount': sessionsCount,
    };

    return _dio.put<dynamic>(
      '$path/$patientId',
      data: data,
    );
  }

  Future<Response<dynamic>> deletePatient({
    required String patientId,
    String path = EndPointUrl.addPatient,
  }) async {
    return _dio.delete<dynamic>(
      '$path/$patientId',
    );
  }

  Future<Map<String, dynamic>> getCurrentUserData({
    String path = EndPointUrl.currentUser,
  }) async {
    final Response<dynamic> response = await _dio.get<dynamic>(path);
    final dynamic payload = response.data;

    if (payload is! Map<String, dynamic>) {
      return <String, dynamic>{};
    }

    return _mergeUserPayload(payload);
  }

  Future<Map<String, dynamic>> getCurrentUserProfile({
    String path = EndPointUrl.currentUser,
  }) {
    return getCurrentUserData(path: path);
  }

  Future<Response<dynamic>> updateCurrentUserProfile({
    required String fullName,
    required String email,
    required String phone,
    required String location,
    required String specialty,
    required String hospital,
    required int yearsOfExperience,
    required String bio,
    String path = EndPointUrl.currentUser,
  }) {
    final Map<String, dynamic> data = <String, dynamic>{
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'location': location,
      'specialty': specialty,
      'hospital': hospital,
      'yearsOfExperience': yearsOfExperience,
      'bio': bio,
    };

    return _dio.put<dynamic>(
      path,
      data: data,
    );
  }

  Map<String, dynamic> _mergeUserPayload(Map<String, dynamic> payload) {
    final Map<String, dynamic> merged = Map<String, dynamic>.from(payload);

    _mergeIfMap(merged, payload['data']);
    _mergeIfMap(merged, payload['user']);
    _mergeIfMap(merged, payload['profile']);

    final dynamic data = payload['data'];
    if (data is Map<String, dynamic>) {
      _mergeIfMap(merged, data['user']);
      _mergeIfMap(merged, data['profile']);
    }

    return merged;
  }

  void _mergeIfMap(Map<String, dynamic> target, dynamic value) {
    if (value is Map<String, dynamic>) {
      target.addAll(value);
    }
  }

  List<Map<String, dynamic>> _extractPatientRows(dynamic payload) {
    if (payload is List) {
      return payload.whereType<Map<String, dynamic>>().toList();
    }

    if (payload is Map<String, dynamic>) {
      final List<Map<String, dynamic>> directRows =
          _extractPatientRows(payload['patients']);
      if (directRows.isNotEmpty) {
        return directRows;
      }

      final List<Map<String, dynamic>> dataRows =
          _extractPatientRows(payload['data']);
      if (dataRows.isNotEmpty) {
        return dataRows;
      }

      final List<Map<String, dynamic>> resultRows =
          _extractPatientRows(payload['result']);
      if (resultRows.isNotEmpty) {
        return resultRows;
      }

      return <Map<String, dynamic>>[payload];
    }

    return <Map<String, dynamic>>[];
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
