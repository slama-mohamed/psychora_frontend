import 'package:flutter/material.dart';
import 'package:psychora/core/styles/form_styles.dart';
import 'package:psychora/features/edit_profile/presentation/widget/labelfield.dart';
import 'package:psychora/features/edit_profile/presentation/widget/profile_hero_card.dart';
import 'package:psychora/features/edit_profile/presentation/widget/row_buttons.dart';
import 'package:psychora/features/edit_profile/presentation/widget/section_card.dart';
import 'package:psychora/features/edit_profile/presentation/widget/text_editprofile.dart';

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({super.key});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController(text: 'Dr. Mohamed Slama');
  final _emailController = TextEditingController(
    text: 'mohamed.slama@ensi-uma.tn',
  );
  final _phoneController = TextEditingController(text: '+212 6 12 34 56 78');
  final _specialityController = TextEditingController(
    text: 'Clinical Psychology',
  );
  final _bioController = TextEditingController(
    text:
        'Passionate about helping students manage stress and build healthy habits.',
  );

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _specialityController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  String? _requiredField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF0F9F6),
                  Color(0xFFFBFDFC),
                  Color(0xFFF5F8FA),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
          Positioned(
            top: -80,
            left: -80,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF3D9970).withValues(alpha: 0.09),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3D9970).withValues(alpha: 0.05),
                    blurRadius: 70,
                    spreadRadius: 15,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF2D7A5C).withValues(alpha: 0.07),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2D7A5C).withValues(alpha: 0.04),
                    blurRadius: 80,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        color: const Color(0xFF1F2937),
                      ),
                      const Expanded(child: TextEditprofile()),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      8,
                      20,
                      size.width < 380 ? 20 : 28,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 680),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ProfileHeroCard(
                                fullName: _fullNameController.text,
                                email: _emailController.text,
                              ),
                              const SizedBox(height: 20),
                              SectionCard(
                                title: 'Personal Information',
                                subtitle:
                                    'Keep your profile details up to date.',
                                child: Column(
                                  children: [
                                    LabeledField(
                                      label: 'Full Name',
                                      child: TextFormField(
                                        controller: _fullNameController,
                                        style: FormStyles.inputTextStyle,
                                        validator: _requiredField,
                                        decoration: FormStyles.baseDecoration(
                                          icon: Icons.person_outline_rounded,
                                          hint: 'Enter your full name',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    LabeledField(
                                      label: 'Email',
                                      child: TextFormField(
                                        controller: _emailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        style: FormStyles.inputTextStyle,
                                        validator: _requiredField,
                                        decoration: FormStyles.baseDecoration(
                                          icon: Icons.email_outlined,
                                          hint: 'Enter your email',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    LabeledField(
                                      label: 'Phone Number',
                                      child: TextFormField(
                                        controller: _phoneController,
                                        keyboardType: TextInputType.phone,
                                        style: FormStyles.inputTextStyle,
                                        validator: _requiredField,
                                        decoration: FormStyles.baseDecoration(
                                          icon: Icons.call_outlined,
                                          hint: 'Enter your phone number',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              SectionCard(
                                title: 'Professional Details',
                                subtitle:
                                    'Show your role and expertise clearly.',
                                child: Column(
                                  children: [
                                    LabeledField(
                                      label: 'Speciality',
                                      child: TextFormField(
                                        controller: _specialityController,
                                        style: FormStyles.inputTextStyle,
                                        validator: _requiredField,
                                        decoration: FormStyles.baseDecoration(
                                          icon:
                                              Icons.workspace_premium_outlined,
                                          hint: 'Example: Clinical Psychology',
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 14),

                                    LabeledField(
                                      label: 'Bio',
                                      child: TextFormField(
                                        controller: _bioController,
                                        maxLines: 4,
                                        style: FormStyles.inputTextStyle,
                                        validator: _requiredField,
                                        decoration: FormStyles.baseDecoration(
                                          icon: Icons.notes_rounded,
                                          hint:
                                              'Write a short introduction about yourself',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),

                              RowButtons(formKey: _formKey),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
