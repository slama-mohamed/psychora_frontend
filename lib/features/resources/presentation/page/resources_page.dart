import 'package:flutter/material.dart';
import 'package:psychora/common/widgets/bottom_navigation/home_bottom_navigation_bar.dart';
import '../widget/resources_form.dart';

class ResourcesPage extends StatelessWidget {
  const ResourcesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: const SafeArea(
        child: ResourcesForm(),
      ),
      bottomNavigationBar: const HomeBottomNavigationBar(),
    );
  }
}