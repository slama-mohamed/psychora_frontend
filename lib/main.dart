import 'package:flutter/material.dart';
import 'package:psychora/features/complete_signup_doctor/presentation/widget/complete_form.dart';

void main() {
  runApp(const Myapp()) ;
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:CompleteProfiledoctor(),
    );
  }
}