import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            // Header avec Avatar
            ProfileHeader(
              initials: 'DR',
              name: 'Dr. Ahmed Hassan',
              profession: 'Psychiatrist',
              isAvailable: true,
            ),
            const SizedBox(height: 30),

            // Information Cards
            InformationSection(),
            const SizedBox(height: 20),

            // Stats Section
            StatSection(),
            const SizedBox(height: 30),

            // Action Buttons
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
      ),
    );
  }
}
