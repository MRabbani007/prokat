import 'dart:async';

import 'package:prokat/core/config/env.dart';
import 'package:prokat/features/chat/state/chat_message_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class ChatSocketService {
  static const String joinChatEvent = 'join_chat';
  static const String leaveChatEvent = 'leave_chat';
  static const String sendMessageEvent = 'send_message';
  static const String newMessageEvent = 'new_message';

  io.Socket? _socket;
  String? _joinedChatId;

  bool get isConnected => _socket?.connected ?? false;

  Future<void> connect({required String token}) async {
    if (isConnected) {
      return;
    }

    _socket?.dispose();
    _socket = io.io(
      Env.baseUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({
            if (token.isNotEmpty) 'Authorization': 'Bearer $token',
          })
          .build(),
    );

    final completer = Completer<void>();
    _socket?.onConnect((_) {
      if (!completer.isCompleted) {
        completer.complete();
      }
    });
    _socket?.onConnectError((error) {
      if (!completer.isCompleted) {
        completer.completeError(Exception(error.toString()));
      }
    });

    _socket?.connect();
    await completer.future.timeout(
      const Duration(seconds: 10),
      onTimeout: () => throw Exception('Socket connection timed out'),
    );
  }

  void onNewMessage(void Function(ChatMessageModel message) handler) {
    _socket?.off(newMessageEvent);
    _socket?.on(newMessageEvent, (payload) {
      if (payload is Map<String, dynamic>) {
        handler(ChatMessageModel.fromJson(payload));
        return;
      }

      if (payload is Map) {
        handler(ChatMessageModel.fromJson(Map<String, dynamic>.from(payload)));
      }
    });
  }

  Future<void> joinChat(String chatId) async {
    if (_joinedChatId == chatId) {
      return;
    }

    if ((_joinedChatId ?? '').isNotEmpty) {
      leaveChat(_joinedChatId!);
    }

    _socket?.emit(joinChatEvent, {'chatId': chatId});
    _joinedChatId = chatId;
  }

  void leaveChat(String chatId) {
    _socket?.emit(leaveChatEvent, {'chatId': chatId});
    if (_joinedChatId == chatId) {
      _joinedChatId = null;
    }
  }

  void sendMessage({
    required String chatId,
    required String message,
    required String type,
    String? clientTempId,
  }) {
    _socket?.emit(sendMessageEvent, {
      'chatId': chatId,
      'message': message,
      'type': type,
      if ((clientTempId ?? '').isNotEmpty) 'clientTempId': clientTempId,
    });
  }

  void disconnect() {
    if ((_joinedChatId ?? '').isNotEmpty) {
      leaveChat(_joinedChatId!);
    }

    _socket?.off(newMessageEvent);
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }
}
