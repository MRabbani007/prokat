import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/user/state/user_profile_provider.dart';
import 'package:go_router/go_router.dart';

void editPhoneSheet(BuildContext context, WidgetRef ref, String currentPhone) {
  final controller = TextEditingController(text: currentPhone);

  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF1E1E1E),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Edit Phone", style: TextStyle(color: Colors.white)),
            const SizedBox(height: 12),

            TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "+7 700...",
                hintStyle: TextStyle(color: Colors.white54),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => context.pop(),
                    child: const Text("Cancel"),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await ref
                          .read(userProfileProvider.notifier)
                          .updateUserProfile(
                            phoneCountryCode: "KZ",
                            phoneNumber: controller.text.trim(),
                          );

                      context.pop();
                    },
                    child: const Text("Save"),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
