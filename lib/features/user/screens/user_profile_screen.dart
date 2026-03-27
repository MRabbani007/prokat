import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/core/widgets/page_header.dart';
import 'package:prokat/features/locations/state/location_provider.dart';
import 'package:prokat/features/user/state/user_profile_provider.dart';
import 'package:prokat/features/user/widgets/build_info_tile.dart';
import 'package:prokat/features/user/widgets/display_name.dart';
import 'package:prokat/features/user/widgets/edit_phone_sheet.dart';
import 'package:prokat/features/user/widgets/show_edit_username.dart';

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const bgColor = Color(0xFF121417); // Matches Sidebar
    const cardColor = Color(0xFF1E2125); // Slightly lighter for depth
    const accentColor = Color(0xFF4E73DF); // Industrial Blue

    final state = ref.watch(userProfileProvider);
    final userAddresses = ref.watch(locationProvider).addresses;
    final selectedAddress = userAddresses
        .where((address) => state.userProfile?.selectedAddressId == address.id)
        .firstOrNull;

    final username = state.userProfile?.username;

    return Scaffold(
      backgroundColor: bgColor,
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
                          color: accentColor.withValues(alpha: 0.5),
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
                        decoration: const BoxDecoration(
                          color: accentColor,
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
              BuildInfoTile(
                icon: Icons.phone_android_rounded,
                label: "Phone Number",
                value: state.userProfile?.phoneNumber ?? "+7 234 ...",
                cardColor: cardColor,
                onTap: () => editPhoneSheet(
                  context,
                  ref,
                  state.userProfile?.phoneNumber ?? "",
                ),
                trailing: const Icon(Icons.edit, color: Colors.white54),
              ),
              BuildInfoTile(
                icon: Icons.email_outlined,
                label: "Email Address",
                value: username ?? "Add username",
                cardColor: cardColor,
                onTap: () => showEditUsernameSheet(context, ref, username),

                // onTap: username == null
                //     ? () => showEditUsernameSheet(context, ref, username)
                //     : null,
                trailing: username == null
                    ? const Icon(Icons.add, color: Colors.white54)
                    : null,
              ),
              BuildInfoTile(
                icon: Icons.location_on_outlined,
                label: "Primary Address",
                value: selectedAddress != null
                    ? selectedAddress.street
                    : "Select address",
                cardColor: cardColor,

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

              const SizedBox(height: 40),

              // Action Button
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 24),
              //   child: SizedBox(
              //     width: double.infinity,
              //     height: 56,
              //     child: ElevatedButton(
              //       onPressed: () {},
              //       style: ElevatedButton.styleFrom(
              //         backgroundColor: accentColor,
              //         foregroundColor: Colors.white,
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(16),
              //         ),
              //         elevation: 8,
              //         shadowColor: accentColor.withValues(alpha: 0.4),
              //       ),
              //       child: const Text(
              //         "Edit Profile",
              //         style: TextStyle(
              //           fontWeight: FontWeight.bold,
              //           fontSize: 16,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
