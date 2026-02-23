import 'package:flutter/material.dart';
import 'package:psychora/features/complete_signup_doctor/presentation/page/doctor_profile_page.dart';
import 'package:psychora/features/complete_signup_student/presentation/widget/complete_form.dart';

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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DoctorProfilePage(),
        ),
      );
    }
    if (selectedRole == "Student") {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const CompleteProfileStudent(),
    ),
  );
}
  }

  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

}