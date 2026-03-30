import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/features/locations/state/location_provider.dart';
// import 'your_location_provider_path.dart';

class SelectAddressSheet extends ConsumerWidget {
  final String? equipmentId;

  const SelectAddressSheet({super.key, this.equipmentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationState = ref.watch(locationProvider);
    final addresses = locationState.renterLocations.take(3).toList();

    const bgColor = Color(0xFF121417);
    // const accentColor = Color(0xFF4E73DF);

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Handle bar
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          const Text(
            "SELECT ADDRESS",
            style: TextStyle(
              color: Colors.white30,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),

          const SizedBox(height: 16),

          /// Recent History List
          if (addresses.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "No recent addresses",
                style: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
              ),
            )
          else
            ...addresses.map(
              (address) => _AddressHistoryTile(
                address: address,
                onTap: () {
                  ref.read(locationProvider.notifier).selectAddress(address);
                  Navigator.pop(context);
                },
              ),
            ),

          const SizedBox(height: 24),

          /// Choose on Map Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                context.push(
                  '/addresses/pintomap',
                  extra: {'equipmentId': equipmentId},
                );
              },
              icon: const Icon(Icons.map_outlined, size: 20),
              label: const Text(
                "CHOOSE ON MAP",
                style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                backgroundColor: Colors.white.withValues(alpha: 0.03),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressHistoryTile extends StatelessWidget {
  final dynamic address;
  final VoidCallback onTap;

  const _AddressHistoryTile({required this.address, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          Icons.history,
          color: Colors.white.withOpacity(0.3),
          size: 20,
        ),
        title: Text(
          "${address.street}, ${address.city}",
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Colors.white.withOpacity(0.1),
          size: 18,
        ),
      ),
    );
  }
}
