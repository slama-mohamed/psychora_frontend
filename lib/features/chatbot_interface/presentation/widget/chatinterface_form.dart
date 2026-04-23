import 'package:flutter/material.dart';
import 'package:psychora/features/chatbot_interface/data/chat_conversation_store.dart';
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
  final ChatConversationStore _chatConversationStore = ChatConversationStore();
  final List<ChatMessage> messages = [];
  bool _isSending = false;
  bool _isLoadingConversation = true;

  String get _conversationKey =>
      (widget.patientId != null && widget.patientId!.trim().isNotEmpty)
          ? widget.patientId!.trim()
          : 'global_chat';

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
    _loadConversation();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadConversation() async {
    final List<Map<String, dynamic>> storedMessages =
        _chatConversationStore.getConversation(_conversationKey);

    if (storedMessages.isNotEmpty) {
      messages
        ..clear()
        ..addAll(_fromStorePayload(storedMessages));

      if (mounted) {
        setState(() {
          _isLoadingConversation = false;
        });
      }
      return;
    }

    if (widget.patientId != null && widget.patientId!.trim().isNotEmpty) {
      try {
        final List<Map<String, dynamic>> backendMessages =
            await _chatServices.loadConversation(patientId: widget.patientId!.trim());

        if (!mounted) {
          return;
        }

        if (backendMessages.isNotEmpty) {
          messages
            ..clear()
            ..addAll(_fromStorePayload(backendMessages));
          _persistConversation();
          setState(() {
            _isLoadingConversation = false;
          });
          return;
        }
      } catch (_) {
        // Fall back to local cache when backend history is unavailable.
      }
    }

    messages.add(
      ChatMessage(
        text: _welcomeText,
        isUser: false,
        timestamp: 'Just now',
      ),
    );
    _persistConversation();

    if (mounted) {
      setState(() {
        _isLoadingConversation = false;
      });
    }
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
    _persistConversation();

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
      _persistConversation();
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
      _persistConversation();
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
      _persistConversation();
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

  List<ChatMessage> _fromStorePayload(List<Map<String, dynamic>> payload) {
    return payload
        .map(
          (Map<String, dynamic> entry) => ChatMessage(
            text: _normalizeLegacyDefaultMessage((entry['content'] ?? '').toString()),
            isUser: (entry['role'] ?? 'assistant').toString() == 'user',
            timestamp: (entry['timestamp'] ?? getCurrentTime()).toString(),
          ),
        )
        .where((ChatMessage message) => message.text.trim().isNotEmpty)
        .toList();
  }

  String _normalizeLegacyDefaultMessage(String text) {
    final String normalized = text.trim();

    const String oldGenericWelcome =
        'Bonjour! Je suis Psychora, votre assistant de sante mentale. Comment puis-je vous aider aujourd\'hui?';
    const String oldGenericWelcomeAccented =
        'Bonjour! Je suis Psychora, votre assistant de santé mentale. Comment puis-je vous aider aujourd\'hui?';
    const String oldResumedPrefix = 'Bonjour! Conversation reprise avec ';
    const String oldResumedSuffix = '. Comment puis-je vous aider aujourd\'hui ?';

    if (normalized == oldGenericWelcome || normalized == oldGenericWelcomeAccented) {
      return 'Hello! I am Psychora, your mental health assistant. How can I help you today?';
    }

    if (normalized.startsWith(oldResumedPrefix) && normalized.endsWith(oldResumedSuffix)) {
      final String extractedName = normalized
          .substring(oldResumedPrefix.length, normalized.length - oldResumedSuffix.length)
          .trim();

      final String patientName = extractedName.isNotEmpty
          ? extractedName
          : (widget.patientName ?? '').trim();

      if (patientName.isNotEmpty) {
        return 'Hello! Conversation resumed with $patientName. How can I help you today?';
      }

      return 'Hello! I am Psychora, your mental health assistant. How can I help you today?';
    }

    return text;
  }

  Future<void> _persistConversation() async {
    _chatConversationStore.saveConversation(_conversationKey, _buildHistory());

    if (widget.patientId == null || widget.patientId!.trim().isEmpty) {
      return;
    }

    try {
      await _chatServices.saveConversation(
        patientId: widget.patientId!.trim(),
        history: _buildHistory(),
      );
    } catch (_) {
      // Keep the local cache even if the backend write fails.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_isLoadingConversation)
          const LinearProgressIndicator(
            minHeight: 2,
            color: Color(0xFF3D9970),
            backgroundColor: Colors.transparent,
          ),
        if (_isLoadingConversation) const SizedBox(height: 12),
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
          enabled: !_isSending && !_isLoadingConversation,
          isLoading: _isSending,
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  
}

