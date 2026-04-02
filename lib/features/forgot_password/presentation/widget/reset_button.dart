import 'package:flutter/material.dart';
import 'package:psychora/features/forgot_password/presentation/function/handle_resetpassword_navigation.dart';

class ResetButton extends StatelessWidget {
  final GlobalKey<FormState>? formkey;
  const ResetButton({super.key, this.formkey});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // action reset password
          if (formkey != null && formkey!.currentState!.validate()) {
            // Perform reset password action
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('A password reset link has been sent to your email.'),
                backgroundColor: Color(0xFF3D9970),
              ),
            );
            handleresetpasswordnavigation(context);
          }
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15),
          backgroundColor: const Color(0xFF3D9970),
        ),
        child: Text(
          'Send Reset Link',
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
