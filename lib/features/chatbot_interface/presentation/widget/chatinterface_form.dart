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
  late final ChatServices _chatServices;
  final List<ChatMessage> messages = [];
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _chatServices = ChatServices();
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

  Future<void> _sendMessage() async {
    if (_isSending) return;

    final String userText = _messageController.text.trim();
    if (userText.isEmpty) return;

    setState(() {
      messages.add(
        ChatMessage(
          text: userText,
          isUser: true,
          timestamp: getCurrentTime(),
        ),
      );
      _messageController.clear();
      _isSending = true;
    });

    try {
      final String botReply = await _chatServices.sendMessage(
        userMessage: userText,
        history: _buildHistory(),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        messages.add(
          ChatMessage(
            text: botReply,
            isUser: false,
            timestamp: getCurrentTime(),
          ),
        );
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        messages.add(
          ChatMessage(
            text: 'Impossible de joindre le chatbot pour le moment. Détail: $error',
            isUser: false,
            timestamp: getCurrentTime(),
          ),
        );
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  List<Map<String, dynamic>> _buildHistory() {
    return messages
        .map(
          (ChatMessage message) => <String, dynamic>{
            'role': message.isUser ? 'user' : 'assistant',
            'content': message.text,
            'timestamp': message.timestamp,
          },
        )
        .toList();
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
          onSend: () {
            _sendMessage();
          },
          enabled: !_isSending,
          isLoading: _isSending,
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  
}

