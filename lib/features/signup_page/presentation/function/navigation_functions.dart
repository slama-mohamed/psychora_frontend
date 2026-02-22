import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:psychora/core/constants/route_name.dart';

class AppNavigationFunctions {

  static void navigateToDoctorProfile(BuildContext context) {
    context.pushNamed(RouteName.doctorprofilepage);
  }

  static void navigateToCompleteProfileStudent(BuildContext context) {
    context.pushNamed(RouteName.completeProfileStudent);
  }

  static void navigateToLogin(BuildContext context) {
    context.pushNamed(RouteName.loginName);
  }
}