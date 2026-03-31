import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/features/equipment/providers/equipment_provider.dart';
import 'package:prokat/features/locations/state/location_provider.dart';

void openLocationPickerSheet(
  BuildContext context,
  WidgetRef ref,
  String equipmentId,
) {
  const ghostGray = Color(0x4DFFFFFF);
  const accentBlue = Color(0xFF4E73DF);

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      // 1. Fetch locations from your provider
      final locations = ref.watch(locationProvider).ownerLocations;
      final topLocations = locations.take(5).toList();

      return Container(
        decoration: const BoxDecoration(
          color: Color(0xFF121417),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          border: Border(top: BorderSide(color: Color(0x14FFFFFF), width: 1)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start, // Move header to left
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "SELECT LOCATION",
              style: TextStyle(
                color: ghostGray,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 16),

            // 2. Display Top 3 Locations
            if (topLocations.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "No saved locations yet",
                  style: TextStyle(color: Colors.white24, fontSize: 13),
                ),
              )
            else
              ...topLocations.map(
                (loc) => _LocationActionTile(
                  icon: Icons.location_on_outlined,
                  title: loc.street,
                  subtitle: loc.city,
                  onTap: () async {
                    // Update your notifier with the selection
                    final res = await ref
                        .read(equipmentProvider.notifier)
                        .updateEquipmentLocation(equipmentId, {
                          "id": equipmentId,
                          "locationId": loc.id,
                        });

                    if (res == true) {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),

            const SizedBox(height: 8),
            const Divider(color: Colors.white10),
            const SizedBox(height: 8),

            // 3. Simple "Add New" Button
            InkWell(
              onTap: () {
                Navigator.pop(context);
                context.push("/owner/addresses/map?equipmentId=$equipmentId");
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.add_location_alt_rounded,
                      color: accentBlue,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Create new on map",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ],
                ),
              ),
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

  const _LocationActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
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
