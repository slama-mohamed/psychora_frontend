import 'package:flutter/material.dart';
import 'package:psychora/features/chatbot_interface/presentation/widget/chatinterface_form.dart';

class ChatbotInterface extends StatelessWidget {
  const ChatbotInterface({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Psychora Chatbot',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: const ChatinterfaceForm(),
        ),
      ),
    );
  }
}