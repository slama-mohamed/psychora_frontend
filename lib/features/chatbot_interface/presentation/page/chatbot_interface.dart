import 'package:flutter/material.dart';

class ChatbotInterface extends StatelessWidget {
  const ChatbotInterface({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("chatbot"),
        centerTitle: true,
      ),
      
    );
  }
}