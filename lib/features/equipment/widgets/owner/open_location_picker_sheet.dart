import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void openLocationPickerSheet(
  BuildContext context,
  WidgetRef ref,
  String equipmentId,
) {
  // const bgColor = Color(0xFF1E2125); // Industrial Charcoal
  const ghostGray = Color(0x4DFFFFFF);
  // const accentBlue = Color(0xFF4E73DF);

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return Container(
        decoration: const BoxDecoration(
          color: Color(0xFF121417), // Deep Midnight
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(28),
          ), // Large Radius
          border: Border(
            top: BorderSide(
              color: Color(0x14FFFFFF),
              width: 1,
            ), // Rim light on top edge
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Industrial Drag Handle
            Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "Select Location",
              style: TextStyle(
                color: ghostGray,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            /// Actions
            _LocationActionTile(
              icon: Icons.history_rounded,
              title: "Saved Addresses",
              subtitle: "Select from your frequently used spots",
              onTap: () {
                Navigator.pop(context);
                context.push("/owner/addresses");
              },
            ),

            _LocationActionTile(
              icon: Icons.terminal_rounded,
              title: "Enter New Address",
              subtitle: "Type in the address details manually",
              onTap: () {
                Navigator.pop(context);
                context.push("/owner/addresses/create");
              },
            ),

            _LocationActionTile(
              icon: Icons.map_outlined,
              title: "Pick on Map",
              subtitle: "Drag a pin to the exact location",
              onTap: () {
                Navigator.pop(context);
                context.push("/owner/addresses/map?equipmentId=$equipmentId");
              },
              isLast: true,
            ),

            const SizedBox(height: 32),
          ],
        ),
      );
    },
  );
}

class _LocationActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isLast;

  const _LocationActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    const accentBlue = Color(0xFF4E73DF);
    const ghostGray = Color(0x4DFFFFFF);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.2), // Recessed panel
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: accentBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: accentBlue, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(color: ghostGray, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: ghostGray,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
