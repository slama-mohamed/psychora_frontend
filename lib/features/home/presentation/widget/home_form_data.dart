import 'package:flutter/material.dart';
import 'package:psychora/features/home/presentation/widget/quick_action_item.dart';
import 'package:psychora/features/home/presentation/widget/recentactivityitem.dart';

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

  static final List<QuickActionItem> quickActions = [
    QuickActionItem(
      title: 'New Patient',
      icon: Icons.add,
      backgroundColor: Color(0xFF3D9970),
      foregroundColor: Colors.white,
      onTap: null,
    ),
    QuickActionItem(
      title: 'Start Chat',
      icon: Icons.chat_bubble_outline,
      backgroundColor: Color(0xFF3B82F6),
      foregroundColor: Colors.white,
      onTap: null,
    ),
    QuickActionItem(
      title: 'Resources',
      icon: Icons.menu_book_outlined,
      backgroundColor: Color(0xFF8B5CF6),
      foregroundColor: Colors.white,
      onTap: () {
        // TODO: Add navigation to resources page
        print('Resources tapped');
      },
    ),
    QuickActionItem(
      title: 'All Notes',
      icon: Icons.note_alt_outlined,
      backgroundColor: Color(0xFFF97316),
      foregroundColor: Colors.white,
      onTap: () {
        // TODO: Add navigation to notes page
        print('All Notes tapped');
      },
    ),
  ];
}