import 'package:flutter/material.dart';
import 'package:psychora/core/constants/assets_constant.dart';
import 'package:psychora/features/reset_password/presentation/widget/password_field.dart';
import 'package:psychora/features/reset_password/presentation/widget/confirm_password_field.dart';
import 'package:psychora/features/reset_password/presentation/widget/reset_button.dart';

class Resetpasswordform extends StatefulWidget {
  const Resetpasswordform({super.key});

  @override
  State<Resetpasswordform> createState() => _ResetpasswordformState();
}

class _ResetpasswordformState extends State<Resetpasswordform> {
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                      Column(
                        children: [
                          const Text(
                            'Create New Password',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Enter your new password and confirm it',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'New Password',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                PasswordField(controller: _passwordController),
                const SizedBox(height: 24),
                const Text(
                  'Confirm Password',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                ConfirmPasswordField(
                  controller: _confirmPasswordController,
                  passwordController: _passwordController,
                ),
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