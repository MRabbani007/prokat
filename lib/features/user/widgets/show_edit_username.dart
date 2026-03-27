import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/user/state/user_profile_provider.dart';

void showEditUsernameSheet(
  BuildContext context,
  WidgetRef ref,
  String? currentUsername,
) {
  final isLocked =
      currentUsername != null && currentUsername.isNotEmpty;
  final controller = TextEditingController(text: currentUsername ?? "");

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFF1E1E1E),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Title
            const Text(
              "Set Username",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            /// Info (important UX)
            Text(
              isLocked
                  ? "Username cannot be changed once set."
                  : "Choose a username. This can only be set once.",
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            /// Input
            TextField(
              controller: controller,
              enabled: !isLocked,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "username",
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                ),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// Actions
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Close"),
                  ),
                ),

                if (!isLocked)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final username = controller.text.trim();

                        if (username.isEmpty) return;

                        /// optional validation
                        if (username.length < 3) return;

                        final res = await ref
                            .read(userProfileProvider.notifier)
                            .updateUserName(username);

                        if (res == true) {
                          Navigator.pop(context);
                        }
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
