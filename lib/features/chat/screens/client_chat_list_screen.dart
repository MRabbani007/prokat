import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/core/router/app_routes.dart';
import 'package:prokat/features/chat/state/chat_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/features/chat/widgets/chat_tile.dart';

class ClientChatListScreen extends ConsumerWidget {
  final String? bookingId;
  final String? requestId;

  const ClientChatListScreen({super.key, this.bookingId, this.requestId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final chatState = ref.watch(chatProvider);
    final chats = chatState.conversations;

    // Effect to handle navigation to a specific chat if IDs are provided
    // useEffect(() {
    //   if (bookingId != null || requestId != null) {
    //     final existingChatId = ref
    //         .read(chatProvider.notifier)
    //         .getChatId(bookingId: bookingId, requestId: requestId);

    //     if (existingChatId.toString().isNotEmpty) {
    //       // Push to the specific chat if found
    //       context.push('${AppRoutes.chat}/$existingChatId');
    //     }
    //   }
    //   return null;
    // }, [bookingId, requestId]);

    return Scaffold(
      appBar: AppBar(
        title: Text("Messages", style: theme.textTheme.titleLarge),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: chatState.isLoading == true
          ? const Center(child: CircularProgressIndicator())
          : chatState.error != null
          ? Center(child: Text("Error loading chats: ${chatState.error}"))
          : chats.isEmpty
          ? _buildEmptyChats(theme)
          : ListView.builder(
              itemCount: chats.length,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemBuilder: (context, index) {
                final chat = chats[index];
                return ChatTile(
                  chat: chat,
                  onTap: () => context.push('${AppRoutes.chat}/${chat.id}'),
                );
              },
            ),
    );
  }

  Widget _buildEmptyChats(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 64, color: theme.disabledColor),
          const SizedBox(height: 16),
          Text("No conversations yet", style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }
}
