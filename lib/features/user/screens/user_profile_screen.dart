import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:prokat/core/widgets/page_header.dart';
import 'package:prokat/features/auth/widgets/logout_button.dart';
import 'package:prokat/features/user/state/user_profile_provider.dart';
import 'package:prokat/features/user/widgets/become_owner_cta.dart';
import 'package:prokat/features/user/widgets/build_info_tile.dart';
import 'package:prokat/features/user/widgets/display_name.dart';
import 'package:prokat/features/user/widgets/edit_phone_sheet.dart';
import 'package:prokat/features/user/widgets/setting_link_tile.dart';
import 'package:prokat/features/user/widgets/show_edit_username.dart';
import 'package:go_router/go_router.dart';

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(userProfileProvider);
    // final userAddresses = ref.watch(locationProvider).renterLocations;
    // final selectedAddress = userAddresses
    //     .where((address) => state.userProfile?.selectedAddressId == address.id)
    //     .firstOrNull;
    final username = state.userProfile?.username;
    final profileImageUrl = state.userProfile?.profileImageUrl ?? "";

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageHeader(),

              // Padding(
              //   padding: const EdgeInsets.only(left: 12.0, top: 12),
              //   child: Container(
              //     decoration: BoxDecoration(
              //       color: theme.cardColor,
              //       borderRadius: BorderRadius.circular(30),
              //       boxShadow: [
              //         BoxShadow(
              //           color: Colors.black.withValues(alpha: 0.7),
              //           blurRadius: 10,
              //           offset: const Offset(0, 4),
              //         ),
              //       ],
              //     ),
              //     child: IconButton(
              //       icon: const Icon(Icons.arrow_back),
              //       color: const Color.fromARGB(255, 61, 63, 65),
              //       onPressed: () {
              //         if (context.canPop()) {
              //           context.pop();
              //         }
              //       },
              //     ),
              //   ),
              // ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width:
                                108, // slightly bigger than avatar (100 + padding)
                            height: 108,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.25),
                                  blurRadius: 20,
                                  spreadRadius: 2,
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
                                color: theme.colorScheme.outline.withValues(
                                  alpha: 0.6,
                                ),
                                width: 2,
                              ),
                              color: theme
                                  .colorScheme
                                  .surface, // important for clean edge
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: theme.colorScheme.surface,
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
                      ),
                    ),

                    const SizedBox(width: 12),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DisplayName(),

                        const SizedBox(height: 4), // Rating

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.star,
                              size: 18,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              (state.userProfile?.rating ?? 0).toStringAsFixed(
                                1,
                              ),
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),

                        /// Member since
                        if (state.userProfile?.createdAt != null)
                          Text(
                            "Member since ${DateFormat('MMMM yyyy').format(state.userProfile!.createdAt!)}",
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // 2. Info Section (Cards)
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
              InfoTile(
                icon: Icons.email_outlined,
                label: "Email Address",
                value: username ?? "Add username",
                onTap: () => showEditUsernameSheet(context, ref, username),

                // onTap: username == null
                //     ? () => showEditUsernameSheet(context, ref, username)
                //     : null,
                trailing: username == null
                    ? const Icon(Icons.add, color: Colors.white54)
                    : null,
              ),

              const SizedBox(height: 20),

              BecomeOwnerCTA(),

              const SizedBox(height: 20),

              /// Support / Growth
              SettingsLinkTile(
                icon: Icons.favorite_outline,
                title: 'Support Us',
                subtitle: 'Donate or help us grow',
                onTap: () {
                  context.push('/support-us');
                },
              ),

              /// Legal
              SettingsLinkTile(
                icon: Icons.description_outlined,
                title: 'Terms & Conditions',
                onTap: () {
                  context.push('/terms');
                },
              ),

              /// Help & Support
              SettingsLinkTile(
                icon: Icons.help_outline,
                title: 'Help & Support',
                subtitle: 'Get help or contact support',
                onTap: () {
                  context.push('/help');
                },
              ),

              LogoutButton(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
