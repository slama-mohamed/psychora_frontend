import 'package:flutter/material.dart';
import 'package:psychora/core/network/api_service.dart';
import 'package:psychora/features/profile_page/data/user_profile_model.dart';
import 'package:psychora/features/profile_page/presentation/widget/action_buttons.dart';
import 'package:psychora/features/profile_page/presentation/widget/information_section.dart';
import 'package:psychora/features/profile_page/presentation/widget/profile_header.dart';
import 'package:psychora/features/profile_page/presentation/widget/stat_section.dart';

class ProfilepageForm extends StatefulWidget {
  const ProfilepageForm({super.key});

  @override
  State<ProfilepageForm> createState() => _ProfilepageFormState();
}

class _ProfilepageFormState extends State<ProfilepageForm> {
  bool _isEditing = false;
  final ApiService _apiService = ApiService();
  late Future<UserProfileModel> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadUserProfile();
  }

  Future<UserProfileModel> _loadUserProfile() async {
    final Map<String, dynamic> payload = await _apiService.getCurrentUserProfile();
    return UserProfileModel.fromApi(payload);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: FutureBuilder<UserProfileModel>(
        future: _profileFuture,
        builder: (BuildContext context, AsyncSnapshot<UserProfileModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF3D9970),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                      color: Color(0xFFDC2626),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Impossible de charger vos informations.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _profileFuture = _loadUserProfile();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3D9970),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Reessayer'),
                    ),
                  ],
                ),
              ),
            );
          }

          final UserProfileModel profile =
              snapshot.data ?? UserProfileModel.fromApi(<String, dynamic>{});

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                ProfileHeader(
                  initials: profile.initials,
                  name: profile.fullName,
                  profession: profile.profession,
                  isAvailable: profile.isAvailable,
                ),
                const SizedBox(height: 30),

                InformationSection(
                  email: profile.email,
                  phone: profile.phone,
                  location: profile.location,
                  specialization: profile.specialization,
                ),
                const SizedBox(height: 20),

                StatSection(
                  patientsCount: profile.patientsCount,
                  sessionsCount: profile.sessionsCount,
                  rating: profile.rating,
                ),
                const SizedBox(height: 30),

                ActionButtons(
                  onEdit: () {
                    setState(() => _isEditing = !_isEditing);
                  },
                  onSettings: () {
                    // navigation settings
                  },
                  onLogout: () {
                    // logout logic
                  },
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}
