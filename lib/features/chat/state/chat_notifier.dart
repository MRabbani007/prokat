import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/core/config/env.dart';
import 'package:prokat/features/auth/services/auth_secure_storage.dart';
import 'package:prokat/features/chat/state/chat_message_model.dart';
import 'package:prokat/features/chat/state/chat_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'chat_service.dart';
import 'chat_state.dart';

class ChatNotifier extends StateNotifier<ChatState> {
  final ChatService service;
  final AuthSecureStorage secureStorage;
  IO.Socket? _socket;

  ChatNotifier(this.service, this.secureStorage) : super(ChatState()) {
    getConversations();
    connectWebSocket();
  }

  void connectWebSocket() async {
    if (_socket != null && _socket!.connected) return;

    final session = await secureStorage.readSession();
    final token = session?.sessionToken ?? "";

    _socket = IO.io(
      Env.baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .build(),
    );

    _socket?.onConnect((_) {
      print('Socket connected');
    });

    _socket?.on('receive_message', (data) {
      if (data != null) {
        final newMessage = ChatMessageModel.fromJson(data);
        if (state.currentChat?.id == newMessage.conversationId) {
          state = state.copyWith(
            messages: [newMessage, ...state.messages],
          );
        }
        
        // Also update conversations list with last message
        updateConversationLastMessage(newMessage.conversationId, newMessage);
      }
    });

    _socket?.onDisconnect((_) => print('Socket disconnected'));
  }

  void disconnectWebSocket() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  @override
  void dispose() {
    disconnectWebSocket();
    super.dispose();
  }

  void updateConversationLastMessage(String conversationId, ChatMessageModel msg) {
    if (state.conversations.isEmpty) return;
    final index = state.conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      final updatedLists = List<ChatModel>.from(state.conversations);
      // We don't have a copyWith for ChatModel but we can create a new instance or if we had it.
      // Since it's a model, let's just make a new one reflecting the last message
      final old = updatedLists[index];
      updatedLists[index] = ChatModel(
        id: old.id,
        participantIds: old.participantIds,
        bookingId: old.bookingId,
        requestId: old.requestId,
        lastMessage: msg,
        createdAt: old.createdAt,
        updatedAt: DateTime.now(),
      );
      state = state.copyWith(conversations: updatedLists);
    }
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

    state = state.copyWith(messages: [tempMessage, ...state.messages]);

    final sent = await service.sendMessage(
      conversationId: chat.id,
      message: text,
    );

    if (sent != null) {
      // Opt UI handled, but socket might stream it back, need deduplication typically.
      // updateConversationLastMessage(chat.id, sent);
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

      return null;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }
}
