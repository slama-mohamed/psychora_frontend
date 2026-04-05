class ChatConversationStore {
  ChatConversationStore._internal();

  static final ChatConversationStore _instance = ChatConversationStore._internal();

  factory ChatConversationStore() => _instance;

  final Map<String, List<Map<String, dynamic>>> _conversationsByPatient =
      <String, List<Map<String, dynamic>>>{};

  List<Map<String, dynamic>> getConversation(String key) {
    final List<Map<String, dynamic>>? existing = _conversationsByPatient[key];
    if (existing == null) {
      return <Map<String, dynamic>>[];
    }
    return existing
        .map((Map<String, dynamic> message) => Map<String, dynamic>.of(message))
        .toList();
  }

  void saveConversation(String key, List<Map<String, dynamic>> messages) {
    _conversationsByPatient[key] = messages
        .map((Map<String, dynamic> message) => Map<String, dynamic>.of(message))
        .toList();
  }

  void clearConversation(String key) {
    _conversationsByPatient.remove(key);
  }
}
