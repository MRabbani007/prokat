import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:prokat/features/auth/widgets/logout_button.dart';
import 'package:prokat/features/user/state/user_profile_provider.dart';
import 'package:prokat/features/user/widgets/become_owner_cta.dart';
import 'package:prokat/features/user/widgets/build_info_tile.dart';
import 'package:prokat/features/user/widgets/display_name.dart';
import 'package:prokat/features/user/widgets/edit_phone_sheet.dart';
import 'package:prokat/features/user/widgets/setting_link_tile.dart';
import 'package:prokat/features/user/widgets/show_edit_username.dart';
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
    final username = state.userProfile?.username;
    final profileImageUrl = state.userProfile?.profileImageUrl ?? "";

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
                        _buildProfileImage(theme, profileImageUrl),
                        const SizedBox(width: 16),
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
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 20),

              InfoTile(
                icon: Icons.phone_android_rounded,
                label: "Phone Number",
                value: state.userProfile?.phoneNumber ?? "+7 234 ...",
                onTap: () => showEditPhoneSheet(
                  context,
                  ref,
                  state.userProfile?.phoneNumber ?? "",
                ),
                trailing: const Icon(Icons.edit, color: Colors.white54),
              ),

              const SizedBox(height: 20),

              InfoTile(
                icon: Icons.email_outlined,
                label: "Email Address",
                value: username ?? "Add username",
                onTap: () => showEditUsernameSheet(context, ref, username),
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

              SettingsLinkTile(
                icon: Icons.description_outlined,
                title: 'Terms & Conditions',
                onTap: () => context.push('/terms'),
              ),

              SettingsLinkTile(
                icon: Icons.help_outline,
                title: 'Help & Support',
                subtitle: 'Get help or contact support',
                onTap: () => context.push('/help'),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: const LogoutButton(),
              ),

              const SizedBox(height: 40), // Bottom spacing
            ]),
          ),
        ],
      ),
    );
  }

  // Helper to keep the build method clean
  Widget _buildProfileImage(ThemeData theme, String url) {
    return Stack(
      children: [
        Container(
          width: 108,
          height: 108,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.6),
              width: 2,
            ),
            color: theme.colorScheme.surface,
          ),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: theme.colorScheme.surface,
            backgroundImage: NetworkImage(url),
            child: url.isEmpty ? const Icon(Icons.person, size: 40) : null,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 4,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.edit_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfo(BuildContext context, dynamic state) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const DisplayName(),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.star, size: 18, color: Colors.amber),
            const SizedBox(width: 6),
            Text(
              (state.userProfile?.ratingStars ?? 0).toStringAsFixed(1),
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ],
        ),
        if (state.userProfile?.createdAt != null)
          Text(
            "Member since ${DateFormat('MMMM yyyy').format(state.userProfile!.createdAt!)}",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onPrimary.withValues(alpha: 0.6),
            ),
          ),
      ],
    );
  }
}
