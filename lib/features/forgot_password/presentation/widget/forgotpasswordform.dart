import 'package:flutter/material.dart';
import 'package:psychora/core/constants/assets_constant.dart';
import 'package:psychora/features/forgot_password/presentation/widget/mytext.dart';
import 'package:psychora/features/forgot_password/presentation/widget/reset_button.dart';
import 'package:psychora/features/forgot_password/presentation/widget/email_field.dart';
import 'package:psychora/features/forgot_password/presentation/widget/textemail.dart';

class Forgotpasswordform extends StatefulWidget {
  const Forgotpasswordform({super.key});

  @override
  State<Forgotpasswordform> createState() => _ForgotpasswordformState();
}

class _ForgotpasswordformState extends State<Forgotpasswordform> {
  late final TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 50),
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        AssetsConstant.appLogo,
                        width: 160,
                        height: 160,
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
                     
                      const SizedBox(height: 40),

                      Mytext(),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                Textemail(),
                
                const SizedBox(height: 8),
                
                EmailField(controller: _emailController),
                
                const SizedBox(height: 40),
                
                ResetButton(formkey: _formKey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
