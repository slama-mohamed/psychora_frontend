import 'package:dio/dio.dart';
import 'package:psychora/core/constants/end_point_url.dart';
import 'package:psychora/core/network/api_service.dart';

String getCurrentTime() {
  final now = DateTime.now();
  return '${now.hour}:${now.minute.toString().padLeft(2, '0')}';
}

class ChatServices {
  ChatServices({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  final ApiService _apiService;

  Future<String> sendMessage({
    required String userMessage,
    List<Map<String, dynamic>> history = const <Map<String, dynamic>>[],
  }) async {
    try {
      final response = await _apiService.dio.post<dynamic>(
        EndPointUrl.chatbotMessage,
        data: <String, dynamic>{
          'message': userMessage,
          'history': history,
        },
      );

      final String? parsedReply = _extractReply(response.data);
      if (parsedReply == null || parsedReply.trim().isEmpty) {
        throw Exception('Réponse du chatbot invalide.');
      }

      return parsedReply;
    } on DioException catch (error) {
      throw Exception(_extractApiError(error));
    }
  }

  Future<List<Map<String, dynamic>>> loadConversation({
    required String patientId,
  }) async {
    try {
      return await _apiService.getPatientConversation(patientId: patientId);
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> saveConversation({
    required String patientId,
    required List<Map<String, dynamic>> history,
  }) async {
    try {
      await _apiService.dio.post<dynamic>(
        EndPointUrl.patientConversation,
        data: <String, dynamic>{
          'patientId': patientId,
          'messages': history,
        },
      );
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> clearConversation({
    required String patientId,
  }) async {
    try {
      await _apiService.dio.delete<dynamic>(
        '${EndPointUrl.patientConversation}/$patientId',
      );
    } catch (error) {
      throw Exception(error.toString());
    }
  }
  
  String? _extractReply(dynamic payload) {
    if (payload is String && payload.trim().isNotEmpty) {
      return payload;
    }

    if (payload is! Map<String, dynamic>) {
      return null;
    }

    const List<String> directKeys = <String>[
      'reply',
      'response',
      'message',
      'text',
      'answer',
      'content',
    ];

    for (final String key in directKeys) {
      final dynamic value = payload[key];
      if (value is String && value.trim().isNotEmpty) {
        return value;
      }
    }

    final dynamic nestedData = payload['data'];
    if (nestedData is Map<String, dynamic>) {
      for (final String key in directKeys) {
        final dynamic value = nestedData[key];
        if (value is String && value.trim().isNotEmpty) {
          return value;
        }
      }
    }

    final dynamic choices = payload['choices'];
    if (choices is List && choices.isNotEmpty) {
      final dynamic firstChoice = choices.first;
      if (firstChoice is Map<String, dynamic>) {
        final dynamic message = firstChoice['message'];
        if (message is Map<String, dynamic>) {
          final dynamic content = message['content'];
          if (content is String && content.trim().isNotEmpty) {
            return content;
          }
        }
      }
    }

    return null;
  }

  String _extractApiError(DioException error) {
    final dynamic responseData = error.response?.data;

    if (responseData is Map<String, dynamic>) {
      const List<String> errorKeys = <String>[
        'message',
        'error',
        'detail',
        'description',
      ];

      for (final String key in errorKeys) {
        final dynamic value = responseData[key];
        if (value is String && value.trim().isNotEmpty) {
          return value;
        }
      }
    }

    return 'Erreur reseau lors de la communication avec le chatbot.';
  }

}