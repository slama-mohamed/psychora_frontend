import 'package:flutter/material.dart';
import 'package:psychora/features/chatbot_interface/data/chat_conversation_store.dart';
import 'package:psychora/features/chatbot_interface/presentation/widget/chatinterface_form.dart';

class ChatbotInterface extends StatefulWidget {
  final String? patientId;
  final String? patientName;

  const ChatbotInterface({
    super.key,
    this.patientId,
    this.patientName,
  });

  @override
  State<ChatbotInterface> createState() => _ChatbotInterfaceState();
}

class _ChatbotInterfaceState extends State<ChatbotInterface> {
  final ChatConversationStore _chatConversationStore = ChatConversationStore();
  int _conversationViewVersion = 0;

  String get _conversationKey =>
      (widget.patientId != null && widget.patientId!.trim().isNotEmpty)
          ? widget.patientId!.trim()
          : 'global_chat';

  void _startNewConversation() {
    _chatConversationStore.clearConversation(_conversationKey);
    setState(() {
      _conversationViewVersion++;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Nouvelle conversation démarrée.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          widget.patientName == null || widget.patientName!.trim().isEmpty
              ? 'Psychora Chatbot'
              : 'Chat - ${widget.patientName!.trim()}',
          style: const TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _startNewConversation,
            tooltip: 'Nouvelle conversation',
            icon: const Icon(
              Icons.add_comment_outlined,
              color: Color(0xFF1F2937),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ChatinterfaceForm(
            key: ValueKey<String>('${_conversationKey}_$_conversationViewVersion'),
            patientId: widget.patientId,
            patientName: widget.patientName,
          ),
        ),
      ),
    );
  }
}