import 'package:flutter/material.dart';
import 'package:psychora/features/profile_page/presentation/widget/stat_card.dart';

class StatSection extends StatelessWidget {
  const StatSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: StatCard(number: '247', label: 'Patients'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StatCard(number: '1.2K', label: 'Sessions'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StatCard(number: '4.8', label: 'Rating'),
          ),
        ],
      ),
    );
  }
}
