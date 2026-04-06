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
  late final TextEditingController controller;

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

    final parts = newName.split(' ');

    final success = await ref
        .read(userProfileProvider.notifier)
        .updateUserProfile(
          firstName: parts.first,
          lastName: parts.length > 1 ? parts.sublist(1).join(' ') : '',
        );

    if (success == true) {
      setState(() => isEditing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final state = ref.watch(userProfileProvider);
    final name = state.userProfile?.displayName ?? '';
    final isLoading = state.isLoading;

    if (isEditing) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Constrained width input
            TextField(
              controller: controller,
              autofocus: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => submit(),
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: 'Enter name',
                hintStyle: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.5),
                ),
                filled: true,
                fillColor: theme.cardColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: cancelEditing,
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: isLoading ? null : submit,
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      );
    }

    /// 👇 Display mode
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(width: 8),
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => startEditing(name),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.edit,
                size: 18,
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
