import 'package:flutter/material.dart';
import 'package:psychora/core/network/api_service.dart';
import 'package:psychora/features/chatbot_interface/presentation/function/chatservices.dart';
import 'package:psychora/features/chatbot_interface/presentation/widget/chatmessage.dart';
import 'package:psychora/features/chatbot_interface/presentation/widget/inputarea.dart';
import 'package:psychora/features/chatbot_interface/presentation/widget/messagebubble.dart';

class ChatinterfaceForm extends StatefulWidget {
  final String? patientId;
  final String? patientName;

  const ChatinterfaceForm({
    super.key,
    this.patientId,
    this.patientName,
  });

  @override
  State<ChatinterfaceForm> createState() => _ChatinterfaceFormState();
}

class _ChatinterfaceFormState extends State<ChatinterfaceForm> {
  late final TextEditingController _messageController;
  late final ChatServices _chatServices;
  final ApiService _apiService = ApiService();
  final List<ChatMessage> messages = [];
  bool _isSending = false;

  String get _welcomeText {
    if (widget.patientName != null && widget.patientName!.trim().isNotEmpty) {
      return 'Hello! Conversation resumed with ${widget.patientName!.trim()}. How can I help you today?';
    }
    return 'Hello! I am Psychora, your mental health assistant. How can I help you today?';
  }

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _chatServices = ChatServices();
    _loadConversationHistory();
  }

  Future<void> _loadConversationHistory() async {
    final String patientId = (widget.patientId ?? '').trim();
    if (patientId.isEmpty) {
      // Add welcome message if no patient
      messages.add(
        ChatMessage(
          text: _welcomeText,
          isUser: false,
          timestamp: 'Just now',
        ),
      );
      setState(() {});
      return;
    }

    try {
      final List<Map<String, dynamic>> history = await _apiService.getPatientConversation(
        patientId: patientId,
      );

      print('Loaded ${history.length} messages from history for patient $patientId');

      if (!mounted) return;

      if (history.isNotEmpty) {
        // Convert history to ChatMessage
        for (final Map<String, dynamic> msg in history) {
          final String role = msg['role'] ?? msg['sender'] ?? '';
          final String content = msg['content'] ?? msg['message'] ?? msg['text'] ?? '';
          final String timestamp = msg['timestamp'] ?? msg['createdAt'] ?? 'Unknown';

          if (content.isNotEmpty) {
            messages.add(
              ChatMessage(
                text: content,
                isUser: role.toLowerCase() == 'user',
                timestamp: _formatTimestamp(timestamp),
              ),
            );
          }
        }
        print('Added ${messages.length} messages to UI for patient $patientId');
      } else {
        // Add welcome message if no history
        messages.add(
          ChatMessage(
            text: _welcomeText,
            isUser: false,
            timestamp: 'Just now',
          ),
        );
      }
    } catch (error) {
      print('Error loading conversation history for patient $patientId: $error');
      // On error, add welcome message
      messages.add(
        ChatMessage(
          text: _welcomeText,
          isUser: false,
          timestamp: 'Just now',
        ),
      );
    }

    setState(() {});
  }

  String _formatTimestamp(String timestamp) {
    if (timestamp.trim().isEmpty) {
      return '';
    }

    DateTime? dt;
    try {
      dt = DateTime.parse(timestamp);
    } catch (_) {
      try {
        final int epoch = int.parse(timestamp);
        dt = DateTime.fromMillisecondsSinceEpoch(epoch);
      } catch (_) {
        dt = null;
      }
    }

    if (dt == null) {
      return '';
    }

    final String hour = dt.hour.toString().padLeft(2, '0');
    final String minute = dt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
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

    final String activePatientId = (widget.patientId ?? '').trim();
    if (activePatientId.isEmpty) {
      setState(() {
        messages.add(
          ChatMessage(
            text: 'Impossible to reach the chatbot: unidentified patient.',
            isUser: false,
            timestamp: getCurrentTime(),
          ),
        );
        _isSending = false;
      });
      return;
    }
    try {
      final String botReply = await _chatServices.sendMessage(
        patientId: activePatientId,
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
                        'No messages yet',
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

