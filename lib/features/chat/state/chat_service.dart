import 'package:dio/dio.dart';
import 'package:prokat/core/api/api_client.dart';
import 'package:prokat/features/chat/state/chat_message_model.dart';
import 'package:prokat/features/chat/state/chat_model.dart';

class ChatService {
  final ApiClient apiClient;

  ChatService(this.apiClient);

  Dio get _dio => apiClient.dio;

  /// Get all conversations
  Future<List<ChatModel>> getConversations() async {
    try {
      final res = await _dio.get('/chats');

      return (res.data['data'] as List)
          .map((e) => ChatModel.fromJson(e))
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  /// Get messages in a conversation
  Future<List<ChatMessageModel>> getMessages(String conversationId) async {
    try {
      final res = await _dio.get('/chats/$conversationId/messages');

      return (res.data['data'] as List)
          .map((e) => ChatMessageModel.fromJson(e))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Send message
  Future<ChatMessageModel?> sendMessage({
    required String conversationId,
    required String message,
  }) async {
    try {
      final res = await _dio.post(
        '/chats/$conversationId/messages',
        data: {"message": message, "type": "TEXT"},
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        return ChatMessageModel.fromJson(res.data['data']);
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  /// Create or get conversation (important for Prokat use case)
  Future<ChatModel?> createOrGetConversation({required String userId}) async {
    try {
      final res = await _dio.post(
        '/chats/conversations',
        data: {"userId": userId},
      );

      return ChatModel.fromJson(res.data['data']);
    } catch (e) {
      return null;
    }
  }
}
