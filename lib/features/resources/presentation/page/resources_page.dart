import 'package:flutter/material.dart';
import 'package:psychora/common/widgets/bottom_navigation/home_bottom_navigation_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:psychora/core/constants/route_name.dart';
import '../widget/resources_form.dart';

class ResourcesPage extends StatelessWidget {
  const ResourcesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF374151)),
          onPressed: () => context.goNamed(RouteName.chatbotGeneral),
          tooltip: 'Retour au chat',
        ),
        title: const Text(
          'Ressources',
          style: TextStyle(color: Color(0xFF111827), fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: const SafeArea(
        child: ResourcesForm(),
      ),
      bottomNavigationBar: const HomeBottomNavigationBar(),
    );
  }
}