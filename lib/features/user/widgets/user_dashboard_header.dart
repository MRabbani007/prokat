import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/features/user/state/user_profile_provider.dart';
import 'package:prokat/features/user/widgets/language_pill_selector.dart';

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
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Profile image
                    Container(
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

                    // Rating badge
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.amber.withValues(alpha: 0.6),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              size: 12,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              (userProfileState.userProfile?.rating ?? 0)
                                  .toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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

                    // Row(
                    //   children: [
                    //     const Icon(Icons.star, color: Colors.amber, size: 16),
                    //     const SizedBox(width: 4),
                    //     Text(
                    //       (userProfileState.userProfile?.rating ?? 0)
                    //           .toStringAsFixed(1),
                    //       style: TextStyle(
                    //         color: Colors.grey[700],
                    //         fontSize: 14,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),

              // Language selector
              LanguagePillSelector(
                value: selectedLanguage,
                onChanged: (lang) {
                  setState(() => selectedLanguage = lang);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
