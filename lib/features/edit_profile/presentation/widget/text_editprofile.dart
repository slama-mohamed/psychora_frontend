import 'package:flutter/material.dart';

class TextEditprofile extends StatelessWidget {
  const TextEditprofile({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Edit Profile',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'myfont',
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: Color(0xFF103528),
      ),
    );
  }
}
