import 'package:flutter/material.dart';
import 'package:psychora/features/complete_signup_doctor/presentation/widget/action_button.dart';
import 'package:psychora/features/complete_signup_doctor/presentation/widget/professional_input_field.dart';
import 'package:psychora/features/complete_signup_doctor/presentation/widget/profile_header.dart';
import 'package:psychora/features/complete_signup_doctor/presentation/widget/progress_bar.dart';
import 'package:psychora/features/signup_page/presentation/page/signup_page.dart';
import 'package:psychora/core/validators/eight_digit_validator.dart';

class CompleteProfileStudent extends StatefulWidget {
  const CompleteProfileStudent({super.key});

  @override
  State<CompleteProfileStudent> createState() =>
      _CompleteProfileStudentState();
}

class _CompleteProfileStudentState
    extends State<CompleteProfileStudent> {

  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _universityController;
  late final TextEditingController _degreeController;
  late final TextEditingController _yearController;
  late final TextEditingController _locationController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _universityController = TextEditingController();
    _degreeController = TextEditingController();
    _yearController = TextEditingController();
    _locationController = TextEditingController();
    _phoneController = TextEditingController();

    _universityController.addListener(() => setState(() {}));
    _degreeController.addListener(() => setState(() {}));
    _yearController.addListener(() => setState(() {}));
    _locationController.addListener(() => setState(() {}));
    _phoneController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _universityController.dispose();
    _degreeController.dispose();
    _yearController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool _isFormValid() {
    return _universityController.text.isNotEmpty &&
        _degreeController.text.isNotEmpty &&
        _yearController.text.isNotEmpty &&
        _locationController.text.isNotEmpty &&
        _phoneController.text.length == 8;
  }

  void _handleCompleteProfile() {
    if (_formKey.currentState!.validate()) {
      debugPrint("Student profile valid");
    }
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "This field is required";
    }
    return null;
  }

  InputDecoration _dropdownDecoration(IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(
        icon,
        color: const Color(0xFF9CA3AF),
      ),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide:
            const BorderSide(color: Color(0xFF3D9970), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide:
            const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [

              const SizedBox(height: 30),

              const ProfileHeader(
                title: "Complete Your Profile",
                subtitle: "Academic information for students",
              ),

              const SizedBox(height: 20),

              const ProgressBar(
                currentStep: 2,
                totalSteps: 2,
                percentage: 1.0,
              ),

              const SizedBox(height: 25),

              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// UNIVERSITY
                    ProfessionalInputField(
                      label: "UNIVERSITY",
                      hint: "Your university name",
                      icon: Icons.school_outlined,
                      controller: _universityController,
                      validator: _requiredValidator,
                    ),

                    

                    /// DEGREE PROGRAM
                    const Text(
                      'DEGREE PROGRAM',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),

                    DropdownButtonFormField<String>(
                      value: _degreeController.text.isNotEmpty
                          ? _degreeController.text
                          : null,
                      isExpanded: true,
                      hint: const Text(
                        'Select your degree',
                        style:
                            TextStyle(color: Color(0xFF9CA3AF)),
                      ),
                      decoration:
                          _dropdownDecoration(Icons.menu_book_outlined),
                      items: const [
                        DropdownMenuItem(
                            value: 'Medical Student',
                            child: Text('Medical Student')),
                        DropdownMenuItem(
                            value: 'Psychiatry Resident',
                            child: Text('Psychiatry Resident')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _degreeController.text = value ?? '';
                        });
                      },
                      validator: (value) =>
                          (value == null || value.isEmpty)
                              ? 'Please select your degree'
                              : null,
                    ),

                    const SizedBox(height: 18),

                    /// CURRENT YEAR
                    const Text(
                      'CURRENT YEAR',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),

                    DropdownButtonFormField<String>(
                      value: _yearController.text.isNotEmpty
                          ? _yearController.text
                          : null,
                      isExpanded: true,
                      hint: const Text(
                        'Select year',
                        style:
                            TextStyle(color: Color(0xFF9CA3AF)),
                      ),
                      decoration:
                          _dropdownDecoration(Icons.calendar_today_outlined),
                      items: const [
                        DropdownMenuItem(
                            value: '1st Year',
                            child: Text('1st Year')),
                        DropdownMenuItem(
                            value: '2nd Year',
                            child: Text('2nd Year')),
                        DropdownMenuItem(
                            value: '3rd Year',
                            child: Text('3rd Year')),
                        DropdownMenuItem(
                            value: '4th Year',
                            child: Text('4th Year')),
                        DropdownMenuItem(
                            value: '5th Year',
                            child: Text('5th Year')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _yearController.text = value ?? '';
                        });
                      },
                      validator: (value) =>
                          (value == null || value.isEmpty)
                              ? 'Please select your year'
                              : null,
                    ),

                    const SizedBox(height: 18),

                    /// LOCATION
                    ProfessionalInputField(
                      label: "LOCATION",
                      hint: "City, Country",
                      icon: Icons.location_on_outlined,
                      controller: _locationController,
                      validator: _requiredValidator,
                    ),

                    //const SizedBox(height: 10),

                    /// PHONE
                    ProfessionalInputField(
                      label: "PHONE NUMBER",
                      hint: "+216 00 000 000",
                      icon: Icons.phone_outlined,
                      controller: _phoneController,
                      keyboardType: TextInputType.number,
                      validator: EightDigitValidator.validate,
                    ),
                  ],
                ),
              ),

              const SizedBox(height:18),

              ActionButton(
                label: "Complete Profile",
                onPressed: _handleCompleteProfile,
                isEnabled: _isFormValid(),
              ),

              

              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SignupPage()),
                  );
                },
                child: Text(
                  'Back to Sign Up',
                  style: TextStyle(
                      color: Colors.grey.withOpacity(0.8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}