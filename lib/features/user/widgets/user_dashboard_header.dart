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
    final profileImageUrl = userProfileState.userProfile?.profileImageUrl ?? "";

    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 10),
      child: Column(
        children: [
          Row(
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
                          color: theme.colorScheme.outline.withValues(
                            alpha: 0.4,
                          ),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        child: ClipOval(
                          child: Image.network(
                            profileImageUrl,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                const Icon(Icons.person, size: 40),
                          ),
                        ),
                      ),
                    ),

                    // Rating badge
                    Positioned(
                      bottom: -6,
                      right: -10,
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
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          border: Border.all(
                            color: theme.colorScheme.outline.withValues(
                              alpha: 0.4,
                            ),
                            width: 1
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: Color.fromARGB(255, 255, 191, 0),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              (userProfileState.userProfile?.ratingStars ?? 0)
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
                child: Text(
                  userProfileState.userProfile?.displayName ?? 'Hello,',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  // This handles the wrapping/overflow
                  maxLines:
                      1, // Change to 2 if you want it to wrap to a second line
                  overflow: TextOverflow
                      .ellipsis, // Adds "..." if the name is too long
                ),
              ),

              const SizedBox(width: 12),

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
