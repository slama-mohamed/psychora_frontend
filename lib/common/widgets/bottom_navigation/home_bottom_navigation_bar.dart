import 'package:flutter/material.dart';
import 'package:psychora/common/widgets/bottom_navigation/bottombutton.dart';


class HomeBottomNavigationBar extends StatelessWidget {
  const HomeBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE5E7EB), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BottomButton(
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            label: 'Home',
            isActive: true,
            onTap: () {},
          ),
          BottomButton(
            icon: Icons.people_outline,
            activeIcon: Icons.people,
            label: 'Patients',
            isActive: false,
            onTap: () {},
          ),
          BottomButton(
            icon: Icons.menu_book_outlined,
            activeIcon: Icons.menu_book,
            label: 'Resources',
            isActive: false,
            onTap: () {},
          ),
          BottomButton(
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            label: 'Profile',
            isActive: false,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

