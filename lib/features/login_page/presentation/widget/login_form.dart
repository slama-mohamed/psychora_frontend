import 'package:flutter/material.dart';
import 'package:psychora/core/constants/assets_constant.dart';
import 'package:psychora/features/login_page/presentation/widget/email_field.dart';
import 'package:psychora/features/login_page/presentation/widget/last_row.dart';
import 'package:psychora/features/login_page/presentation/widget/login_button.dart';
import 'package:psychora/features/login_page/presentation/widget/password_field.dart';
import 'package:psychora/features/login_page/presentation/widget/psychora_text.dart';
import 'package:psychora/features/login_page/presentation/widget/row_password.dart';
import 'package:psychora/features/login_page/presentation/widget/textemail.dart';
import 'package:psychora/features/login_page/presentation/widget/welcome_text.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formkey= GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 50),
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      AssetsConstant.appLogo,
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.psychology_outlined,
                          color: Color(0xFF3D9970),
                          size: 40,
                        );
                      },
                    ),
          
                    PsychoraText(),
                    SizedBox(height: 8),
                    WelcomeText(),
                  ],
                ),
              ),
              SizedBox(height: 30),
          
              Textemail(),
          
              SizedBox(height: 8),
          
              EmailField(controller: _emailController),
          
              SizedBox(height: 30),
          
              RowPassword(),
          
              SizedBox(height: 8),
          
              PasswordField(controller: _passwordController),
              SizedBox(height: 30,),
          
              LoginButton(onPressed: (){}),
              SizedBox(height: 20,),
              LastRow(),
              
            ],
          ),
        ),
      ),
    );
  }
}
