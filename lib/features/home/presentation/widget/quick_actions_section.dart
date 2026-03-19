import 'package:flutter/material.dart';
import 'package:psychora/features/home/presentation/widget/home_form.dart';
import 'package:psychora/features/home/presentation/widget/quickactiontile.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.0, // taller buttons
            ),
            itemCount: HomeFormData.quickActions.length,
            itemBuilder: (context, index) {
              final item = HomeFormData.quickActions[index];
              return QuickActionTile(item: item);
            },
          ),
        ],
      ),
    );
  }
}

