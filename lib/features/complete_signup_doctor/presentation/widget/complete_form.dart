import 'package:flutter/material.dart';
import 'package:psychora/features/complete_signup_doctor/presentation/widget/action_button.dart';
import 'package:psychora/features/complete_signup_doctor/presentation/widget/professional_input_field.dart';
import 'package:psychora/features/complete_signup_doctor/presentation/widget/profile_header.dart';
import 'package:psychora/features/complete_signup_doctor/presentation/widget/progress_bar.dart';
import 'package:psychora/features/signup_page/presentation/page/signup_page.dart';
import 'package:psychora/core/validators/eight_digit_validator.dart';
import 'package:psychora/core/validators/validation_patterns.dart';

class CompleteProfiledoctor extends StatefulWidget {
  const CompleteProfiledoctor({super.key});

  @override
  State<CompleteProfiledoctor> createState() => _CompleteProfiledoctorState();
}

class _CompleteProfiledoctorState extends State<CompleteProfiledoctor> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _specialtyController;
  late final TextEditingController _idCardController;
  late final TextEditingController _hospitalController;
  late final TextEditingController _locationController;
  late final TextEditingController _phoneController;
  late final TextEditingController _experienceController;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _specialtyController = TextEditingController();
    _idCardController = TextEditingController();
    _hospitalController = TextEditingController();
    _locationController = TextEditingController();
    _phoneController = TextEditingController();
    _experienceController = TextEditingController(text: '0');
    
    // Listen to all controllers to trigger form state updates
    _specialtyController.addListener(() => setState(() {}));
    _idCardController.addListener(() => setState(() {}));
    _hospitalController.addListener(() => setState(() {}));
    _locationController.addListener(() => setState(() {}));
    _phoneController.addListener(() => setState(() {}));
    _experienceController.addListener(() => setState(() {}));
  }

  String? _validateHospital(String? value) {
    if (value == null || value.isEmpty) {
      return 'Hospital is required';
    }
    return null;
  }

  String? _validateLocation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Location is required';
    }
    return null;
  }

  @override
  void dispose() {
    _specialtyController.dispose();
    _idCardController.dispose();
    _hospitalController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  void _handleCompleteProfile() {
    if (_formKey.currentState!.validate()) {
      debugPrint('Form is valid');
      // TODO: Implement profile completion logic
    }
  }

  bool _isFormValid() {
    final experienceValue = int.tryParse(_experienceController.text) ?? 0;
    return _specialtyController.text.isNotEmpty &&
        ValidationPatterns.isValidIdCard(_idCardController.text) &&
        _hospitalController.text.isNotEmpty &&
        _locationController.text.isNotEmpty &&
        ValidationPatterns.isValidPhone(_phoneController.text) &&
        experienceValue > 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),

              /// Profile Header
              const ProfileHeader(
                title: "Complete Your Profile",
                subtitle: "Professional information for doctors",
              ),

              const SizedBox(height: 20),

              /// Progress Bar
              const ProgressBar(
                currentStep: 2,
                totalSteps: 2,
                percentage: 1.0,
              ),

              const SizedBox(height: 25),

              /// Form with Input Fields
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Specialty dropdown attached to the field (menu opens under the field)
                    const Text(
                      'SPECIALTY',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Builder(builder: (ctx) {
                      final hasValue = _specialtyController.text.isNotEmpty;
                      return DropdownButtonFormField<String>(
                        value: hasValue ? _specialtyController.text : null,
                        isExpanded: true,
                        hint: const Text('Select your specialty', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 15)),
                        style: const TextStyle(color: Color(0xFF1F2937), fontSize: 15),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.badge_outlined, color: Color(0xFF9CA3AF), size: 20),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: hasValue ? const BorderSide(color: Color(0xFF3D9970), width: 1) : const BorderSide(color: Color(0xFFE5E7EB), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFF3D9970), width: 1),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Psychiatry', child: Text('Psychiatry')),
                          DropdownMenuItem(value: 'Clinical Psychology', child: Text('Clinical Psychology')),
                          DropdownMenuItem(value: 'Neuropsychology', child: Text('Neuropsychology')),
                          DropdownMenuItem(value: 'Child Psychology', child: Text('Child Psychology')),
                        ],
                        onChanged: (v) => setState(() => _specialtyController.text = v ?? ''),
                        validator: (v) => (v == null || v.isEmpty) ? 'Please select a specialty' : null,
                      );
                    }),
                    const SizedBox(height: 18),
                    ProfessionalInputField(
                      label: "ID CARD NUMBER",
                      hint: "your national ID",
                      icon: Icons.credit_card_outlined,
                      controller: _idCardController,
                      keyboardType: TextInputType.number,
                      validator: EightDigitValidator.validate,
                    ),
                    ProfessionalInputField(
                      label: "HOSPITAL/CLINIC",
                      hint: "Your workplace",
                      icon: Icons.local_hospital_outlined,
                      controller: _hospitalController,
                      validator: _validateHospital,
                    ),
                    ProfessionalInputField(
                      label: "LOCATION",
                      hint: "City, Country",
                      icon: Icons.location_on_outlined,
                      controller: _locationController,
                      validator: _validateLocation,
                    ),
                    ProfessionalInputField(
                      label: "PHONE NUMBER",
                      hint: "+216 00 000 000",
                      icon: Icons.phone_outlined,
                      controller: _phoneController,
                      hintStyle: TextStyle(color: Colors.grey.withOpacity(0.7)),
                      keyboardType: TextInputType.number,
                      validator: EightDigitValidator.validate,
                    ),
                    // Years of experience counter
                    const Text(
                      'YEARS OF EXPERIENCE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => setState(() {
                                  final v = int.tryParse(_experienceController.text) ?? 0;
                                  final next = (v - 1).clamp(0, 100);
                                  _experienceController.text = next.toString();
                                }),
                                icon: const Icon(Icons.remove_circle_outline, color: Color(0xFF9CA3AF)),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _experienceController.text.isEmpty ? '0' : _experienceController.text,
                                style: const TextStyle(fontSize: 15, color: Color(0xFF1F2937)),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: () => setState(() {
                                  final v = int.tryParse(_experienceController.text) ?? 0;
                                  final next = (v + 1).clamp(0, 100);
                                  _experienceController.text = next.toString();
                                }),
                                icon: const Icon(Icons.add_circle_outline, color: Color(0xFF9CA3AF)),
                              ),
                            ],
                          ),
                          Text(
                            'years',
                            style: TextStyle(color: Colors.grey.withOpacity(0.7)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              /// Action Button
              ActionButton(
                label: "Complete Profile",
                onPressed: _handleCompleteProfile,
                isEnabled: _isFormValid(),
              ),

              const SizedBox(height:3),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const SignupPage()),
                  );
                },
                child: Text(
                  'Back to Sign Up',
                  style: TextStyle(color: Colors.grey.withOpacity(0.8)),
                ),
              ),

              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}