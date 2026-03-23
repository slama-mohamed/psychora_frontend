import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:psychora/core/constants/route_name.dart';
import 'package:psychora/core/network/api_service.dart';

Future<void> handleHomeNavigation({
  required BuildContext context,
  required String email,
  required String password,
  String loginPath = '/api/psy/login',
}) async {
  final messenger = ScaffoldMessenger.maybeOf(context);

  try {
    await ApiService().loginUser(
      email: email,
      password: password,
      path: loginPath,
    );

    if (!context.mounted) return;
    context.goNamed(RouteName.home);
  } on DioException catch (error) {
    if (!context.mounted) return;

    messenger?.hideCurrentSnackBar();
    messenger?.showSnackBar(
      SnackBar(
        content: Text(_resolveApiErrorMessage(error)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  } catch (_) {
    if (!context.mounted) return;

    messenger?.hideCurrentSnackBar();
    messenger?.showSnackBar(
      const SnackBar(
        content: Text('Unexpected error during login.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

String _resolveApiErrorMessage(DioException error) {
  final statusCode = error.response?.statusCode;

  if (statusCode == 401) {
    return 'Email or password is incorrect.';
  }

  final data = error.response?.data;
  if (data is Map<String, dynamic>) {
    final message = data['message'];
    if (message is String && message.trim().isNotEmpty) {
      return message;
    }
  }

  return 'Login failed. Please try again.';
}