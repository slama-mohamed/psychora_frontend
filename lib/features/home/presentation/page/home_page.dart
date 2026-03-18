import 'package:flutter/material.dart';
import '../widget/home_form.dart';
import '../widget/home_bottom_navigation_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: const HomeForm(),
        ),
      ),
      bottomNavigationBar: const HomeBottomNavigationBar(),
    );
  }
}