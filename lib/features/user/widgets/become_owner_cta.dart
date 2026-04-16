import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/core/router/app_routes.dart';
import 'package:prokat/features/user/state/user_profile_provider.dart';

class BecomeOwnerCTA extends ConsumerWidget {
  const BecomeOwnerCTA({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(userProfileProvider);
    final role = state.userProfile?.role;
    final isOwner = role == 'OWNER';

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(
          isOwner ? Icons.dashboard_rounded : Icons.storefront,
          size: 32,
        ),
        label: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isOwner ? 'Go to Owner Section' : 'Become an Owner',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isOwner
                    ? Colors.white
                    : theme.colorScheme.onSecondaryContainer,
              ),
            ),
            if (!isOwner) const SizedBox(height: 4),
            if (!isOwner)
              Text(
                'List your equipment, offer services, and connect with clients.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
          ],
        ),
        style: ElevatedButton.styleFrom(
          elevation: 6,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          backgroundColor: isOwner
              ? theme.colorScheme.primary
              : theme.colorScheme.secondaryContainer,
          foregroundColor: isOwner
              ? Colors.white
              : theme.colorScheme.onSecondaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () {
          if (isOwner) {
            context.push(AppRoutes.ownerDashboard);
          } else {
            context.push(AppRoutes.becomeOwner);
          }
        },
      ),
    );
  }
}
