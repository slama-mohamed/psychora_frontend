import 'package:flutter/material.dart';
import 'package:psychora/features/home/presentation/page/home_page.dart';
import 'package:psychora/features/login_page/presentation/page/login_page.dart';
import 'package:psychora/features/login_page/presentation/widget/login_button.dart';


void main() {
  runApp(const Myapp()) ;
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  } 
}