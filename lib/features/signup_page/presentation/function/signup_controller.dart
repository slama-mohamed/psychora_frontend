import 'package:flutter/material.dart';
import 'package:psychora/features/signup_page/presentation/function/navigation_functions.dart';

class SignupController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String selectedRole = 'Doctor';

  void onContinue(BuildContext context) {
    if (!formKey.currentState!.validate()) return;

    final name = fullNameController.text.trim();
    final email = emailController.text.trim();

    debugPrint('Role: $selectedRole | Name: $name | Email: $email');

    // Navigate to doctor profile (student flow removed)
    if (selectedRole == 'Doctor') {
      AppNavigationFunctions.navigateToDoctorProfile(context);
    }
    if (selectedRole == "Student") {
      AppNavigationFunctions.navigateToCompleteProfileStudent(context);
    }
  }

  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
