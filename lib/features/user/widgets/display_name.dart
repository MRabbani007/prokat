import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/user/state/user_profile_provider.dart';

class DisplayName extends ConsumerStatefulWidget {
  const DisplayName({super.key});

  @override
  ConsumerState<DisplayName> createState() => _DisplayNameState();
}

class _DisplayNameState extends ConsumerState<DisplayName> {
  bool isEditing = false;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void startEditing(String currentName) {
    controller.text = currentName;
    setState(() => isEditing = true);
  }

  void cancelEditing() {
    setState(() => isEditing = false);
  }

  Future<void> submit() async {
    final newName = controller.text.trim();
    if (newName.isEmpty) return;

    final nameArray = newName.split(" ");

    final res = await ref
        .read(userProfileProvider.notifier)
        .updateUserProfile(
          firstName: nameArray[0],
          lastName: nameArray.length > 1 ? nameArray[1] : "",
        );

    if (res == true) {
      setState(() => isEditing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userProfileProvider);
    final name = state.userProfile?.displayName ?? "";
    final isLoading = state.isLoading;

    if (isEditing) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "Enter name",
              hintStyle: TextStyle(color: Colors.white54),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(onPressed: cancelEditing, child: const Text("Cancel")),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: isLoading ? null : submit,
                child: const Text("Save"),
              ),
            ],
          ),
        ],
      );
    }

    /// 👇 Display mode
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => startEditing(name),
          child: const Icon(Icons.edit, color: Colors.white70, size: 18),
        ),
      ],
    );
  }
}
