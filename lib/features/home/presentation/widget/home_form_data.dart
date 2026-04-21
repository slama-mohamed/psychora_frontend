import 'package:flutter/material.dart';
import 'package:psychora/features/home/presentation/widget/quick_action_item.dart';
import 'package:psychora/features/home/presentation/widget/recentactivityitem.dart';

class HomeFormData {
  HomeFormData._();

  static const List<RecentActivityItem> todaySessions = [
    RecentActivityItem(
      name: 'Eleanor Pena',
      diagnosis: 'Anxiety Disorder',
      time: '10:00',
      avatarBackgroundColor: Color(0xFFD7F3E8),
      avatarForegroundColor: Color(0xFF2E8B57),
    ),
    RecentActivityItem(
      name: 'Cody Fisher',
      diagnosis: 'Depression Follow-up',
      time: '14:30',
      avatarBackgroundColor: Color(0xFFDDEBFF),
      avatarForegroundColor: Color(0xFF3B82F6),
    ),
    RecentActivityItem(
      name: 'Esther Howard',
      diagnosis: 'PTSD Evaluation',
      time: '16:00',
      avatarBackgroundColor: Color(0xFFF0E0FF),
      avatarForegroundColor: Color(0xFFA855F7),
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