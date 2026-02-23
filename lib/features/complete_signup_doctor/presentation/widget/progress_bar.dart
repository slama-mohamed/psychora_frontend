import 'package:flutter/material.dart';

/// Widget pour afficher la progression (Step + Percentage + Progress Bar)
class ProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final double percentage;

  const ProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Step $currentStep of $totalSteps"),
            Text(
              "${(percentage * 100).toStringAsFixed(0)}%",
              style: const TextStyle(color: Colors.green),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 6,
            backgroundColor: Colors.grey,
            valueColor: const AlwaysStoppedAnimation(Colors.green),
          ),
        ),
      ],
    );
  }
}
