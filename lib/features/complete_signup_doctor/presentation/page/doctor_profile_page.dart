import 'package:flutter/material.dart';
import 'package:psychora/features/complete_signup_doctor/presentation/widget/complete_form.dart';

class DoctorProfilePage extends StatelessWidget {
  const DoctorProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: CompleteProfiledoctor(),
      ),
    );
  }
}
