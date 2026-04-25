import 'package:flutter/material.dart';
import 'package:psychora/features/chatbot_interface/data/chat_conversation_store.dart';
import 'package:psychora/features/chatbot_interface/presentation/function/chatservices.dart';
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
  final ChatServices _chatServices = ChatServices();
  int _conversationViewVersion = 0;
  bool _isLoadingDrawerConversations = false;
  String? _drawerError;

  @override
  void initState() {
    super.initState();
    _loadDrawerConversationsFromBackend();
  }

  String get _conversationKey =>
      (widget.patientId != null && widget.patientId!.trim().isNotEmpty)
          ? widget.patientId!.trim()
          : 'global_chat';

  String _formatIsoDate(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return '';
    }

    try {
      final DateTime date = DateTime.parse(raw).toLocal();
      final String day = date.day.toString().padLeft(2, '0');
      final String month = date.month.toString().padLeft(2, '0');
      final String hour = date.hour.toString().padLeft(2, '0');
      final String minute = date.minute.toString().padLeft(2, '0');
      return '$day/$month ${date.year} - $hour:$minute';
    } catch (_) {
      return raw;
    }
  }

  bool _hasUserMessage(List<Map<String, dynamic>> messages) {
    return messages.any(
      (Map<String, dynamic> message) =>
          (message['role'] ?? '').toString() == 'user' &&
          (message['content'] ?? '').toString().trim().isNotEmpty,
    );
  }

  Future<void> _archiveCurrentConversationIfNeeded() async {
    final List<Map<String, dynamic>> current =
        _chatConversationStore.getConversation(_conversationKey);

    if (current.isEmpty || !_hasUserMessage(current)) {
      return;
    }

    _chatConversationStore.saveConversationSnapshot(
      _conversationKey,
      current,
      patientId: widget.patientId,
    );

    if (widget.patientId == null || widget.patientId!.trim().isEmpty) {
      return;
    }

    try {
      await _chatServices.saveConversation(
        patientId: widget.patientId!.trim(),
        history: current,
      );
    } catch (_) {
      // Keep local snapshot when backend save fails.
    }
  }

  void _openSavedConversation(String id) {
    final List<Map<String, dynamic>> messages =
        _chatConversationStore.getSavedConversationMessages(_conversationKey, id);

    if (messages.isEmpty) {
      return;
    }

    _chatConversationStore.saveConversation(_conversationKey, messages);

    setState(() {
      _conversationViewVersion++;
    });

    Navigator.of(context).pop();
  }

  Future<void> _deleteSavedConversation(String id) async {
    final Map<String, dynamic>? savedConversation =
        _chatConversationStore.getSavedConversation(_conversationKey, id);

    final String fallbackPatientId =
        (savedConversation?['patientId'] ?? widget.patientId ?? '').toString().trim();
    final String backendConversationId =
        (savedConversation?['backendConversationId'] ?? '').toString().trim();

    if (fallbackPatientId.isNotEmpty) {
      try {
        await _chatServices.deleteConversationFromDrawer(
          patientId: fallbackPatientId,
          conversationId: backendConversationId,
        );
      } catch (_) {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to delete this conversation from backend.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
    }

    _chatConversationStore.deleteSavedConversation(_conversationKey, id);
    setState(() {});
  }

  Future<void> _loadDrawerConversationsFromBackend() async {
    if (_isLoadingDrawerConversations) {
      return;
    }

    setState(() {
      _isLoadingDrawerConversations = true;
      _drawerError = null;
    });

    try {
      final List<Map<String, dynamic>> payload =
          await _chatServices.loadPsyConversations();

      final List<Map<String, dynamic>> normalizedSnapshots =
          _normalizeRemoteConversations(payload);

      for (final Map<String, dynamic> snapshot in normalizedSnapshots) {
        final String remotePatientId = (snapshot['patientId'] ?? '').toString().trim();
        final bool isPatientScoped =
            widget.patientId != null && widget.patientId!.trim().isNotEmpty;
        if (isPatientScoped &&
            remotePatientId.isNotEmpty &&
            remotePatientId != widget.patientId!.trim()) {
          continue;
        }

        final dynamic messagesPayload = snapshot['messages'];
        if (messagesPayload is! List) {
          continue;
        }

        final List<Map<String, dynamic>> messages = messagesPayload
            .whereType<Map<String, dynamic>>()
            .map((Map<String, dynamic> item) => Map<String, dynamic>.of(item))
            .toList();

        if (messages.isEmpty) {
          continue;
        }

        _chatConversationStore.saveConversationSnapshot(
          _conversationKey,
          messages,
          patientId: remotePatientId,
          backendConversationId: (snapshot['backendConversationId'] ?? '').toString(),
          title: (snapshot['title'] ?? '').toString(),
          updatedAt: (snapshot['updatedAt'] ?? '').toString(),
        );
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingDrawerConversations = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingDrawerConversations = false;
        _drawerError = 'Unable to load conversations.';
      });
    }
  }

  List<Map<String, dynamic>> _normalizeRemoteConversations(
    List<Map<String, dynamic>> payload,
  ) {
    if (payload.isEmpty) {
      return <Map<String, dynamic>>[];
    }

    final bool payloadIsMessageList = payload.every(_looksLikeMessageEntry);

    if (payloadIsMessageList) {
      final List<Map<String, dynamic>> messages = _normalizeMessages(payload);
      if (messages.isEmpty) {
        return <Map<String, dynamic>>[];
      }

      return <Map<String, dynamic>>[
        <String, dynamic>{
          'patientId': widget.patientId,
          'messages': messages,
        },
      ];
    }

    return payload
        .map((Map<String, dynamic> item) {
          final List<Map<String, dynamic>> messages =
              _extractMessagesFromConversationRow(item);

          if (messages.isEmpty) {
            return <String, dynamic>{};
          }

          return <String, dynamic>{
            'patientId': _extractPatientId(item),
            'backendConversationId': _extractConversationId(item),
            'title': _extractConversationTitle(item),
            'updatedAt': _extractConversationUpdatedAt(item),
            'messages': messages,
          };
        })
        .where((Map<String, dynamic> item) => item.isNotEmpty)
        .toList();
  }

  bool _looksLikeMessageEntry(Map<String, dynamic> item) {
    return item.containsKey('role') ||
        item.containsKey('content') ||
        item.containsKey('message') ||
        item.containsKey('text');
  }

  String _extractPatientId(Map<String, dynamic> row) {
    final dynamic direct = row['patientId'] ?? row['patient_id'] ?? row['idPatient'];
    if (direct != null && direct.toString().trim().isNotEmpty) {
      return direct.toString().trim();
    }

    final dynamic nestedPatient = row['patient'];
    if (nestedPatient is Map<String, dynamic>) {
      final dynamic nestedId = nestedPatient['id'] ?? nestedPatient['_id'];
      if (nestedId != null && nestedId.toString().trim().isNotEmpty) {
        return nestedId.toString().trim();
      }
    }

    return '';
  }

  String _extractConversationId(Map<String, dynamic> row) {
    for (final String key in <String>['conversationId', 'conversation_id', 'id', '_id']) {
      final dynamic value = row[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString().trim();
      }
    }

    return '';
  }

  String _extractConversationTitle(Map<String, dynamic> row) {
    for (final String key in <String>['title', 'name', 'label']) {
      final dynamic value = row[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString().trim();
      }
    }

    return '';
  }

  String _extractConversationUpdatedAt(Map<String, dynamic> row) {
    for (final String key in <String>['updatedAt', 'updated_at', 'lastMessageAt', 'date']) {
      final dynamic value = row[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString().trim();
      }
    }

    return '';
  }

  List<Map<String, dynamic>> _extractMessagesFromConversationRow(
    Map<String, dynamic> row,
  ) {
    final dynamic messagesPayload = row['messages'] ?? row['history'];
    if (messagesPayload is List) {
      return _normalizeMessages(messagesPayload.whereType<Map<String, dynamic>>().toList());
    }

    if (_looksLikeMessageEntry(row)) {
      return _normalizeMessages(<Map<String, dynamic>>[row]);
    }

    return <Map<String, dynamic>>[];
  }

  List<Map<String, dynamic>> _normalizeMessages(
    List<Map<String, dynamic>> rawMessages,
  ) {
    return rawMessages
        .map((Map<String, dynamic> message) {
          final String content =
              (message['content'] ?? message['message'] ?? message['text'] ?? '')
                  .toString()
                  .trim();
          if (content.isEmpty) {
            return <String, dynamic>{};
          }

          final String role =
              (message['role'] ?? message['sender'] ?? 'assistant').toString();
          final String timestamp = (message['timestamp'] ??
                  message['date'] ??
                  message['createdAt'] ??
                  message['created_at'] ??
                  '')
              .toString();

          return <String, dynamic>{
            'role': role,
            'content': content,
            'timestamp': timestamp,
          };
        })
        .where((Map<String, dynamic> item) => item.isNotEmpty)
        .toList();
  }

  Future<void> _startNewConversation() async {
    await _archiveCurrentConversationIfNeeded();
    _chatConversationStore.clearConversation(_conversationKey);
    setState(() {
      _conversationViewVersion++;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('New conversation started.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> savedConversations =
        _chatConversationStore.getSavedConversations(_conversationKey);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      onDrawerChanged: (bool isOpened) {
        if (isOpened) {
          _loadDrawerConversationsFromBackend();
        }
      },
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              const ListTile(
                leading: Icon(Icons.history, color: Color(0xFF1F2937)),
                title: Text(
                  'Saved conversations',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              const Divider(height: 1),
              if (_isLoadingDrawerConversations)
                const LinearProgressIndicator(minHeight: 2),
              if (_drawerError != null)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    _drawerError!,
                    style: const TextStyle(color: Colors.redAccent),
                    textAlign: TextAlign.center,
                  ),
                ),
              Expanded(
                child: savedConversations.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            'No saved conversations yet.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: savedConversations.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final Map<String, dynamic> item = savedConversations[index];
                          final String id = (item['id'] ?? '').toString();
                          final String title =
                              (item['title'] ?? 'Untitled conversation').toString();
                          final String updatedAt =
                              _formatIsoDate((item['updatedAt'] ?? '').toString());

                          return ListTile(
                            leading: const Icon(Icons.chat_bubble_outline),
                            title: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: updatedAt.isEmpty ? null : Text(updatedAt),
                            onTap: () => _openSavedConversation(id),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              tooltip: 'Delete',
                              onPressed: () async {
                                await _deleteSavedConversation(id);
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
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
            onPressed: () async {
              await _startNewConversation();
            },
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