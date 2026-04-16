import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/core/providers/api_provider.dart';

import 'chat_notifier.dart';
import 'chat_service.dart';
import 'chat_state.dart';

final chatServiceProvider = Provider<ChatService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ChatService(apiClient);
});

final chatProvider =
    StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final service = ref.read(chatServiceProvider);
  return ChatNotifier(service);
});