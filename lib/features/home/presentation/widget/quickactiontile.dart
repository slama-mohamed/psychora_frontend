import 'package:flutter/material.dart';
import 'package:psychora/features/home/presentation/widget/home_form.dart';

class QuickActionTile extends StatelessWidget {
  const QuickActionTile({super.key, required this.item});

  final QuickActionItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: item.backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            item.icon,
            size: 26,
            color: item.foregroundColor,
          ),
          const SizedBox(height: 8),
          Text(
            item.title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: item.foregroundColor,
            ),
          ),
        ],
      ),
    );
  }
}