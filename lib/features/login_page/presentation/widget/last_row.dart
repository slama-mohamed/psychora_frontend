import 'package:flutter/material.dart';

class LastRow extends StatelessWidget {
  const LastRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'New To Psychora?',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Color(0xFF6B7280),
            letterSpacing: 0.5,
          ),
        ),

        SizedBox(width: 9),

        GestureDetector(
          onTap: () => {},
          child: Text("SignUp", style: TextStyle(color: Colors.green)),
        ),
      ],
    );
  }
}
