import 'package:flutter/material.dart';
import 'package:psychora/core/constants/assets_constant.dart';

/// Widget pour le header (logo + titre + sous-titre)
class ProfileHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? logoPath;

  const ProfileHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.logoPath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 30),
        _buildLogo(),
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      logoPath ?? AssetsConstant.appLogos,
      width: 120,
      height: 120,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(
          Icons.psychology_outlined,
          color: Color(0xFF3D9970),
          size: 40,
        );
      },
    );
  }
}
