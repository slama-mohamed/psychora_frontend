import 'package:flutter/material.dart';
import 'package:psychora/features/reset_password/presentation/function/handle_login_navigation.dart';

class ResetButton extends StatelessWidget {
  final GlobalKey<FormState>? formkey;
  const ResetButton({super.key, this.formkey});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (formkey != null && formkey!.currentState!.validate()) {
            // Perform reset password action
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Password reset successfully!'),
                backgroundColor: Color(0xFF3D9970),
              ),
            );
            handleLoginNavigation(context);
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          backgroundColor: const Color(0xFF3D9970),
        ),
        child: const Text(
          'Reset Password',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
