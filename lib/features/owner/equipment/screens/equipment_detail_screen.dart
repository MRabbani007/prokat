import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/owner_equipment_provider.dart';

class OwnerEquipmentDetailScreen extends ConsumerWidget {
  final String equipmentId;

  const OwnerEquipmentDetailScreen({super.key, required this.equipmentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ownerEquipmentProvider);
    final equipment = state.equipment.where((e) => e.id == equipmentId).firstOrNull;

    if (equipment == null) {
      return Scaffold(appBar: AppBar(), body: const Center(child: Text("Equipment not found")));
    }

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Details"),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.edit_outlined),
      //       onPressed: () => context.push('/owner/equipment/${equipment.id}/edit'),
      //     ),
      //     IconButton(
      //       icon: const Icon(Icons.delete_outline, color: Colors.red),
      //       onPressed: () => _confirmDelete(context, ref),
      //     ),
      //   ],
      // ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Image Header with Fallback
            _buildImageHeader(equipment.imageUrl),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle("General Info"),
                  _Item("Name", equipment.name),
                  _Item("Model", equipment.model),
                  _Item("Capacity", equipment.capacity),
                  
                  const Divider(height: 32),
                  
                  // 2. Location Section
                  _SectionTitle("Location"),
                  // _buildLocationPreview(equipment.locations[0].name), 

                  const Divider(height: 32),

                  // 3. Dynamic Pricing Section
                  _SectionTitle("Pricing Plans"),
                  // ...equipment.prices.map((p) => _PriceTile(p.rate.toString(), p.price.toDouble(), p.rate.toString())),

                  const Divider(height: 32),

                  // 4. Conditions
                  _SectionTitle("Conditions & Comments"),
                  _Item("Rent Condition", equipment.rentCondition),
                  if (equipment.ownerComment != null)
                    _Item("Owner's Note", equipment.ownerComment!),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageHeader(String? url) {
    return Container(
      width: double.infinity,
      height: 250,
      color: Colors.grey[200],
      child: url != null && url.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 50),
            )
          : const Icon(Icons.image_outlined, size: 80, color: Colors.grey),
    );
  }

  Widget _buildLocationPreview(String? address) {
    return InkWell(
      onTap: () {/* Open Map View */},
      child: Row(
        children: [
          const Icon(Icons.location_on, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              address ?? "No location set (Tap to add pin)",
              style: TextStyle(color: address == null ? Colors.grey : Colors.black87),
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Equipment?"),
        content: const Text("This action cannot be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              // ref.read(ownerEquipmentProvider.notifier).delete(equipmentId);
              Navigator.pop(ctx);
              context.pop();
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _PriceTile extends StatelessWidget {
  final String label, unit;
  final double amount;
  const _PriceTile(this.label, this.amount, this.unit);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.payments_outlined, color: Colors.green),
      title: Text(label), // e.g. "Standard Rate"
      trailing: Text(
        "\$$amount / $unit", // e.g. "$50 / hour"
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title.toUpperCase(),
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueGrey[600])),
    );
  }
}

class _Item extends StatelessWidget {
  final String label, value;
  const _Item(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
