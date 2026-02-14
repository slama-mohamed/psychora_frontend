import 'package:flutter/material.dart';
import 'package:psychora/features/login_page/presentation/widget/email_field.dart';
import 'package:psychora/features/login_page/presentation/widget/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(child: Column(
            children: [
              LoginForm() ,
            ],
          )),
        ),
      ),
    );
  }
}
