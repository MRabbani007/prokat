import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/chat/state/chat_message_model.dart';
import 'package:prokat/features/chat/state/chat_model.dart';
import 'chat_service.dart';
import 'chat_state.dart';

class ChatNotifier extends StateNotifier<ChatState> {
  final ChatService service;

  ChatNotifier(this.service) : super(ChatState()) {
    getConversations();
  }

  Future<void> getConversations() async {
    try {
      state = state.copyWith(isLoading: true);

      final data = await service.getConversations();

      state = state.copyWith(isLoading: false, conversations: data);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> openChat(ChatModel chat) async {
    state = state.copyWith(currentChat: chat, isLoading: true);

    final messages = await service.getMessages(chat.id);

    state = state.copyWith(isLoading: false, messages: messages);
  }

  Future<void> sendMessage(String text) async {
    final chat = state.currentChat;
    if (chat == null) return;

    /// optimistic UI (instant message)
    final tempMessage = ChatMessageModel(
      id: DateTime.now().toString(),
      conversationId: chat.id,
      senderId: "me",
      message: text,
      type: "TEXT",
      createdAt: DateTime.now(),
    );

    state = state.copyWith(messages: [...state.messages, tempMessage]);

    final sent = await service.sendMessage(
      conversationId: chat.id,
      message: text,
    );

    if (sent != null) {
      /// replace temp message (optional improvement)
    }
  }

  Future<void> startChat(String userId) async {
    state = state.copyWith(isLoading: true);

    final chat = await service.createOrGetConversation(userId: userId);

    if (chat != null) {
      await openChat(chat);
    }

    state = state.copyWith(isLoading: false);
  }

  Future<String?> getChatId({String? bookingId, String? requestId}) async {
    try {
      /// 1. Try to find in existing conversations
      final existing = state.conversations.firstWhere(
        (chat) =>
            (bookingId != null && chat.bookingId == bookingId) ||
            (requestId != null && chat.requestId == requestId),
        orElse: () => ChatModel(id: '', participantIds: []),
      );

      if (existing.id.isNotEmpty) {
        return existing.id;
      }

      /// 2. Fallback → refetch from backend
      final chats = await service.getConversations();

      state = state.copyWith(conversations: chats);

      final fetched = chats.firstWhere(
        (chat) =>
            (bookingId != null && chat.bookingId == bookingId) ||
            (requestId != null && chat.requestId == requestId),
        orElse: () => ChatModel(id: '', participantIds: []),
      );

      if (fetched.id.isNotEmpty) {
        return fetched.id;
      }

      /// 3. Optional: create chat if backend supports it
      return null;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }
}
