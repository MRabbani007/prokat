import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/core/widgets/page_header.dart';
import 'package:prokat/features/auth/widgets/logout_button.dart';
import 'package:prokat/features/locations/state/location_provider.dart';
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

    // const cardColor = Color(0xFF1E2125); // Slightly lighter for depth
    // const accentColor = Color(0xFF4E73DF); // Industrial Blue

    final state = ref.watch(userProfileProvider);
    final userAddresses = ref.watch(locationProvider).renterLocations;
    final selectedAddress = userAddresses
        .where((address) => state.userProfile?.selectedAddressId == address.id)
        .firstOrNull;

    final username = state.userProfile?.username;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Reusable Page Header (Customized for clearing FAB)
              const PageHeader(title: "My Profile"),

              const SizedBox(height: 20),

              // 1. Profile Photo Section
              Center(
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                          'https://via.placeholder.com',
                        ), // Replace with actual user photo
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

              const SizedBox(height: 12),

              DisplayName(),

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
              InfoTile(
                icon: Icons.location_on_outlined,
                label: "Primary Address",
                value: selectedAddress != null
                    ? selectedAddress.street
                    : "Select address",
                onTap: () {
                  Scaffold.of(context).openEndDrawer();
                  // OR
                  // context.push(AppRoutes.selectAddress);
                },

                trailing: const Icon(
                  Icons.chevron_right,
                  color: Colors.white54,
                ),
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
