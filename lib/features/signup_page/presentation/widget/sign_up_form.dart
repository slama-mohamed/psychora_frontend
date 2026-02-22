import 'package:flutter/material.dart';
import 'package:psychora/core/constants/assets_constant.dart';
import 'package:psychora/core/validators/signup_form_validator.dart';
import '../function/signup_controller.dart';
import 'fullname_field.dart';
import 'email_field.dart';
import 'password_field.dart';
import 'role_selector.dart';
import '../widget/already_have_account_row.dart';
import '../../../login_page/presentation/widget/welcome_text.dart';

class SignupForm extends StatefulWidget {
  final SignupController controller;

  const SignupForm({super.key, required this.controller});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  @override
  void initState() {
    super.initState();
    widget.controller.fullNameController.addListener(_onChanged);
    widget.controller.emailController.addListener(_onChanged);
    widget.controller.passwordController.addListener(_onChanged);
  }

  @override
  void dispose() {
    widget.controller.fullNameController.removeListener(_onChanged);
    widget.controller.emailController.removeListener(_onChanged);
    widget.controller.passwordController.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() => setState(() {});

  bool get _isFormValid => SignupFormValidator.validateAll(
        fullName: widget.controller.fullNameController.text,
        email: widget.controller.emailController.text,
        password: widget.controller.passwordController.text,
      );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                
                const SizedBox(height: 8),
                
                const WelcomeText(
                  title: 'Create Account',
                  subtitle: 'Join the Psychora community',
                ),
              
              ],
            ),
          ),
         
          const SizedBox(height: 30),
         
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: widget.controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RoleSelector(
                    selectedRole: widget.controller.selectedRole,
                    onRoleChanged: (role) {
                      setState(() => widget.controller.selectedRole = role);
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'FULL NAME',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                      letterSpacing: 0.5,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  FullNameField(controller: widget.controller.fullNameController),
                  const SizedBox(height: 20),
                  const Text(
                    'EMAIL ADDRESS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  EmailField(controller: widget.controller.emailController),
                  const SizedBox(height: 20),
                  const Text(
                    'PASSWORD',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  PasswordFieldSignup(controller: widget.controller.passwordController),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isFormValid
                        ? () {
                            if (widget.controller.formKey.currentState!.validate()) {
                              widget.controller.onContinue(context);
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFormValid ? const Color(0xFF3D9970) : Colors.grey,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                const AlreadyHaveAccountRow(),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}