import 'package:flutter/material.dart';

class WelcomeText extends StatelessWidget {
  const WelcomeText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
                    'Welcome back to your workspace',
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w400,
                    ),
                  );
  }
}