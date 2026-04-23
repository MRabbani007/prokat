import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/auth/widgets/logout_button.dart';
import 'package:prokat/features/user/state/user_profile_provider.dart';
import 'package:prokat/features/user/widgets/become_owner_cta.dart';
import 'package:prokat/features/user/widgets/edit_name_sheet.dart';
import 'package:prokat/features/user/widgets/profile_image_picker.dart';
import 'package:prokat/features/user/widgets/user_profile_tile.dart';
import 'package:prokat/features/user/widgets/display_name.dart';
import 'package:prokat/features/user/widgets/setting_link_tile.dart';
import 'package:go_router/go_router.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({super.key});

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(userProfileProvider.notifier).getUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(userProfileProvider);
    final profileNotifier = ref.read(userProfileProvider.notifier);

    final username = state.userProfile?.username;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180.0,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: theme.colorScheme.onPrimary,
              ),
              onPressed: () => context.pop(),
            ),
            pinned: false,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withValues(alpha: 0.7),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Profile Image Stack
                        ProfileImagePicker(
                          onImageSelected: (file) async {
                            print("image selected");
                            if (file != null) {
                              await profileNotifier.uploadProfileImage(file);
                            }
                          },
                          initialImageUrl:
                              state.userProfile?.profileImageUrl ?? "",
                        ),

                        const SizedBox(width: 20),
                        // Name and Rating Info
                        // Note: Ensure _buildProfileInfo uses theme.colorScheme.onPrimary
                        // for text colors to be readable against the gradient.
                        _buildProfileInfo(context, state),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 2. The Settings/Info List
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ), // Apply your padding here
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 20),

                UserProfileTile(
                  icon: Icons.phone_android_rounded,
                  label: "Phone Number",
                  value: state.userProfile?.phoneNumber ?? "+7 234 ...",
                  onTap: () {},
                  // () => showEditPhoneSheet(
                  //   context,
                  //   ref,
                  //   state.userProfile?.phoneNumber ?? "",
                  // )
                  trailing: const Icon(Icons.edit, color: Colors.white54),
                ),

                const SizedBox(height: 20),

                UserProfileTile(
                  icon: Icons.person,
                  label: "Display Name",
                  value: state.userProfile?.displayName ?? "Add Display Name",
                  onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (_) => EditNameSheet(
                      initialName: state.userProfile?.displayName ?? "",
                    ),
                  ),
                  trailing: username == null
                      ? const Icon(Icons.add, color: Colors.white54)
                      : null,
                ),

                const SizedBox(height: 20),

                const BecomeOwnerCTA(),

                const SizedBox(height: 20),

                SettingsLinkTile(
                  icon: Icons.favorite_outline,
                  title: 'Support Us',
                  subtitle: 'Donate or help us grow',
                  onTap: () => context.push('/support-us'),
                ),

                const SizedBox(height: 20),

                SettingsLinkTile(
                  icon: Icons.description_outlined,
                  title: 'Terms & Conditions',
                  onTap: () => context.push('/terms'),
                ),

                const SizedBox(height: 20),

                SettingsLinkTile(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  subtitle: 'Get help or contact support',
                  onTap: () => context.push('/help'),
                ),

                const SizedBox(height: 20),

                const LogoutButton(),

                const SizedBox(height: 40), // Bottom spacing
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(BuildContext context, dynamic state) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const DisplayName(),
        Row(
          children: [
            const Icon(Icons.star_rate_rounded, size: 30, color: Colors.amber),
            const SizedBox(width: 6),
            Text(
              (state.userProfile?.ratingStars ?? 0).toStringAsFixed(1),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),

            const SizedBox(width: 8),
            Text(
              "- 2 Orders",
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.onPrimary.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
        // if (state.userProfile?.createdAt != null)
        //   Text(
        //     "Member since ${DateFormat('MMMM yyyy').format(state.userProfile!.createdAt!)}",
        //     style: Theme.of(context).textTheme.bodySmall?.copyWith(
        //       color: theme.colorScheme.onPrimary.withValues(alpha: 0.6),
        //     ),
        //   ),
      ],
    );
  }
}
