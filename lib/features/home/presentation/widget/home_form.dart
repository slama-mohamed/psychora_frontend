import 'package:flutter/material.dart';

import 'home_header.dart';
import 'quick_actions_section.dart';
import 'recent_activity_section.dart';

/// Static home page content (no backend yet).
///
/// This follows the pattern used elsewhere in the app (e.g. `LoginForm`).
class HomeForm extends StatelessWidget {
  const HomeForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          HomeHeader(),
          SizedBox(height: 20),
          RecentActivitySection(),
          SizedBox(height: 20),
          QuickActionsSection(),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ─── Models ────────────────────────────────────────────────────
class HomeFormData {
  HomeFormData._();

  static const List<RecentActivityItem> recentActivities = [
    RecentActivityItem(
      title: 'Eleanor Pena',
      subtitle: 'Active Chat',
      timestamp: '2 min ago',
      color: Color(0xFF3D9970),
    ),
    RecentActivityItem(
      title: 'Cody Fisher',
      subtitle: 'New Session',
      timestamp: '15 min ago',
      color: Color(0xFF60A5FA),
    ),
    RecentActivityItem(
      title: 'Esther Howard',
      subtitle: 'Active Chat',
      timestamp: '1 hour ago',
      color: Color(0xFFFBBF24),
    ),
  ];

  static const List<QuickActionItem> quickActions = [
    QuickActionItem(
      title: 'New Patient',
      icon: Icons.add,
      backgroundColor: Color(0xFF3D9970),
      foregroundColor: Colors.white,
    ),
    QuickActionItem(
      title: 'Start Chat',
      icon: Icons.chat_bubble_outline,
      backgroundColor: Color(0xFF3B82F6),
      foregroundColor: Colors.white,
    ),
    QuickActionItem(
      title: 'Resources',
      icon: Icons.menu_book_outlined,
      backgroundColor: Color(0xFF8B5CF6),
      foregroundColor: Colors.white,
    ),
    QuickActionItem(
      title: 'All Notes',
      icon: Icons.note_alt_outlined,
      backgroundColor: Color(0xFFF97316),
      foregroundColor: Colors.white,
    ),
  ];
}

class RecentActivityItem {
  final String title;
  final String subtitle;
  final String timestamp;
  final Color color;

  const RecentActivityItem({
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.color,
  });
}

class QuickActionItem {
  final String title;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;

  const QuickActionItem({
    required this.title,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
  });
}