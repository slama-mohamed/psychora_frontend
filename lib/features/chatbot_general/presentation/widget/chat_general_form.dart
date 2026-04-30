import 'package:flutter/material.dart';
import 'package:psychora/features/chatbot_general/presentation/function/chat_general_services.dart';
import 'package:psychora/features/chatbot_general/presentation/widget/chat_general_input_area.dart';
import 'package:psychora/features/chatbot_general/presentation/widget/chat_general_message.dart';
import 'package:psychora/features/chatbot_general/presentation/widget/chat_general_message_bubble.dart';

class ChatGeneralForm extends StatefulWidget {
  const ChatGeneralForm({super.key});

  @override
  State<ChatGeneralForm> createState() => _ChatGeneralFormState();
}

class _ChatGeneralFormState extends State<ChatGeneralForm> {
  late final TextEditingController _messageController;
  late final ChatGeneralServices _chatServices;
  final List<ChatGeneralMessage> messages = [];
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _chatServices = ChatGeneralServices();
    messages.add(
      const ChatGeneralMessage(
        text: 'Hello! I am Psychora, your mental health assistant. How can I help you today?',
        isUser: false,
        timestamp: 'Just now',
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
        ChatGeneralMessage(
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
          ChatGeneralMessage(
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
          ChatGeneralMessage(
            text: 'Unable to reach the chatbot right now. Detail: $error',
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
          (ChatGeneralMessage message) => <String, dynamic>{
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
        Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[messages.length - 1 - index];
              return ChatGeneralMessageBubble(message: message);
            },
          ),
        ),
        const SizedBox(height: 16),
        ChatGeneralInputArea(
          controller: _messageController,
          onSend: _sendMessage,
          enabled: !_isSending,
          isLoading: _isSending,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
