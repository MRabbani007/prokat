import 'package:flutter/material.dart';
import 'package:prokat/features/chat/state/chat_model.dart';

class ChatTile extends StatelessWidget {
  final ChatModel chat;
  final VoidCallback onTap;

  const ChatTile({super.key, required this.chat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 28,
        backgroundImage: NetworkImage("chat.otherParticipant.avatarUrl"),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "chat.otherParticipant.name",
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "timeago.format(chat.lastMessageAt)",
            style: theme.textTheme.labelSmall,
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            chat.lastMessage?.message ?? "",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: "chat.unreadCount".length > 0
                  ? theme.textTheme.bodyLarge?.color
                  : theme.disabledColor,
            ),
          ),
          // if (chat.bookingId != null)
          //   Padding(
          //     padding: const EdgeInsets.only(top: 4),
          //     child: _ContextBadge(text: "Booking: ${chat.bookingReference}"),
          //   ),
        ],
      ),
      trailing: "chat.unreadCount".length > 0
          ? Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Text(
                "${"chat.unreadCount".length}",
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            )
          : null,
    );
  }
}
