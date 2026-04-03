import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/features/user/state/user_profile_provider.dart';

class UserDashboardHeader extends ConsumerStatefulWidget {
  const UserDashboardHeader({super.key});

  @override
  ConsumerState<UserDashboardHeader> createState() => _UserHeaderState();
}

class _UserHeaderState extends ConsumerState<UserDashboardHeader> {
  String selectedLanguage = 'EN';
  @override
  Widget build(BuildContext context) {
    final userProfileState = ref.watch(userProfileProvider);
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Profile Image
              GestureDetector(
                onTap: () {
                  context.push('/profile'); // GoRouter route
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: accent.withValues(alpha: 0.2),
                      width: 3,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: accent.withValues(alpha: 0.1),
                    child: Icon(Icons.person, color: accent),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Name, Rating, and Location
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + rating
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.push('/profile');
                          },
                          child: Text(
                            userProfileState.userProfile?.displayName ??
                                'Hello',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          (userProfileState.userProfile?.rating ?? 0)
                              .toStringAsFixed(1),
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Language selector
              DropdownButton<String>(
                value: selectedLanguage,
                underline: const SizedBox(),
                items: ['EN', 'RU', 'KZ']
                    .map(
                      (lang) =>
                          DropdownMenuItem(value: lang, child: Text(lang)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedLanguage = value;
                    });
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
