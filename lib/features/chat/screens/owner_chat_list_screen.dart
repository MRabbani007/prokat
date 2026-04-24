import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/core/router/app_routes.dart';
import 'package:prokat/features/chat/state/chat_provider.dart';
import 'package:prokat/features/chat/widgets/chat_tile.dart';
import 'package:shimmer/shimmer.dart';
import 'package:lucide_icons/lucide_icons.dart';

class OwnerChatListScreen extends ConsumerWidget {
  const OwnerChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final chatState = ref.watch(chatProvider);
    final chats = chatState.conversations;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              elevation: 0,
              scrolledUnderElevation: 2,
              backgroundColor: theme.colorScheme.primary,
              leading: IconButton(
                icon: Icon(
                  LucideIcons.chevronLeft,
                  size: 20,
                  color: theme.colorScheme.onPrimary,
                ),
                onPressed: () => context.pop(),
              ),
              title: Text(
                "My Orders",
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              centerTitle: false,
            ),

            if (chatState.isLoading)
              _buildSliverSkeleton(context)
            else if (chatState.error != null)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text("Error loading chats: ${chatState.error}"),
                ),
              )
            else if (chats.isEmpty)
              _buildSliverEmptyState(theme)
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final chat = chats[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ChatTile(
                        chat: chat,
                        onTap: () =>
                            context.push('${AppRoutes.chat}/${chat.id}'),
                      ),
                    );
                  }, childCount: chats.length),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverSkeleton(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Shimmer.fromColors(
            baseColor: Colors.grey.shade200,
            highlightColor: Colors.grey.shade50,
            child: Container(
              height: 80,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          childCount: 5,
        ),
      ),
    );
  }

  Widget _buildSliverEmptyState(ThemeData theme) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_rounded, size: 64, color: theme.disabledColor),
          const SizedBox(height: 16),
          Text(
            "No messages found",
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.disabledColor,
            ),
          ),
        ],
      ),
    );
  }
}
