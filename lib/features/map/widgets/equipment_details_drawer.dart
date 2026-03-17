import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/features/bookings/state/booking_provider.dart';
import 'package:prokat/features/equipment/models/equipment_model.dart';

class EquipmentDetailsDrawer extends ConsumerWidget {
  final Equipment equipment;

  const EquipmentDetailsDrawer({super.key, required this.equipment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DraggableScrollableSheet(
      initialChildSize: 0.35,
      minChildSize: 0.2,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
          ),
          child: Column(
            children: [
              /// Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              /// Scrollable Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.zero, // 🔥 important for image
                  children: [
                    /// 🖼 Image (NO padding)
                    if (equipment.imageUrl != null &&
                        equipment.imageUrl!.isNotEmpty)
                      Image.network(
                        equipment.imageUrl!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),

                    const SizedBox(height: 12),

                    /// 📦 Content
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Name
                          Text(
                            equipment.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          /// Model + Capacity
                          Text(
                            "${equipment.model} • ${equipment.capacity} ${equipment.capacityUnit}",
                            style: TextStyle(color: Colors.grey[700]),
                          ),

                          const SizedBox(height: 16),

                          /// 💰 Prices
                          const Text(
                            "Pricing",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),

                          ...equipment.prices.map(
                            (p) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text("${p.price} / ${p.priceRate}"),
                            ),
                          ),

                          const SizedBox(height: 16),

                          /// 📍 Location
                          if (equipment.locations.isNotEmpty)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.location_on, size: 18),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    "${equipment.locations[0].street}, ${equipment.locations[0].city}",
                                  ),
                                ),
                              ],
                            ),

                          const SizedBox(height: 24),

                          /// ❤️ + 📅 Buttons
                          Row(
                            children: [
                              /// Favorite button
                              IconButton(
                                onPressed: () {
                                  // TODO: implement favorite
                                },
                                icon: const Icon(Icons.favorite_border),
                              ),

                              const SizedBox(width: 8),

                              /// Book button
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    final notifier = ref.read(
                                      bookingProvider.notifier,
                                    );

                                    notifier.startBooking(equipment);

                                    context.push(
                                      '/equipment/${equipment.id}/book',
                                    );
                                  },
                                  child: const Text("Book"),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
