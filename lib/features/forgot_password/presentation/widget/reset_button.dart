import 'package:flutter/material.dart';

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
