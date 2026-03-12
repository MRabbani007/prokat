import 'package:flutter/material.dart';

class DeleteEquipmentSection extends StatelessWidget {
  final VoidCallback onDelete;

  const DeleteEquipmentSection({super.key, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).colorScheme.error.withAlpha(20)),
        color: Theme.of(context).colorScheme.errorContainer.withAlpha(5),
      ),
      child: Column(
        children: [
          const Text(
            "Danger Zone",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_forever_rounded, size: 20),
              label: const Text("Delete this equipment"),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
