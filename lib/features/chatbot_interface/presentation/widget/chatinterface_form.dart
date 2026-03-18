import 'package:flutter/material.dart';
import 'package:psychora/features/chatbot_interface/presentation/function/chatservices.dart';
import 'package:psychora/features/chatbot_interface/presentation/widget/chatmessage.dart';
import 'package:psychora/features/chatbot_interface/presentation/widget/inputarea.dart';
import 'package:psychora/features/chatbot_interface/presentation/widget/messagebubble.dart';

class ChatinterfaceForm extends StatefulWidget {
  const ChatinterfaceForm({super.key});

  @override
  State<ChatinterfaceForm> createState() => _ChatinterfaceFormState();
}

class _ChatinterfaceFormState extends State<ChatinterfaceForm> {
  late final TextEditingController _messageController;
  final List<ChatMessage> messages = [];

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    // Add welcome message
    messages.add(
      const ChatMessage(
        text: 'Bonjour! Je suis Psychora, votre assistant de santé mentale. Comment puis-je vous aider aujourd\'hui?',
        isUser: false,
        timestamp: 'À l\'instant',
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      // Add user message
      messages.add(
        ChatMessage(
          text: _messageController.text,
          isUser: true,
          timestamp: getCurrentTime(),
        ),
      );

      // Simulate bot response
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            messages.add(
              ChatMessage(
                text: 'J\'ai bien compris votre message. Comment puis-je vous aider davantage?',
                isUser: false,
                timestamp: getCurrentTime(),
              ),
            );
          });
        }
      });

      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Messages area
        Expanded(
          child: messages.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 64,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Aucun message',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              
              : ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[messages.length - 1 - index];
                    return MessageBubble(message: message);
                  },
                ),
        ),
        const SizedBox(height: 16),
        // Input area
        InputArea(
          controller: _messageController,
          onSend: _sendMessage,
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  
}

