
import 'package:prokat/features/chat/state/chat_message_model.dart';
import 'package:prokat/features/chat/state/chat_model.dart';

class ChatState {
  final bool isLoading;
  final String? error;

  /// conversation list
  final List<ChatModel> conversations;

  /// current chat
  final ChatModel? currentChat;

  /// messages of current chat
  final List<ChatMessageModel> messages;

  ChatState({
    this.isLoading = false,
    this.error,
    this.conversations = const [],
    this.currentChat,
    this.messages = const [],
  });

  ChatState copyWith({
    bool? isLoading,
    String? error,
    List<ChatModel>? conversations,
    ChatModel? currentChat,
    List<ChatMessageModel>? messages,
  }) {
    return ChatState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      conversations: conversations ?? this.conversations,
      currentChat: currentChat ?? this.currentChat,
      messages: messages ?? this.messages,
    );
  }
}