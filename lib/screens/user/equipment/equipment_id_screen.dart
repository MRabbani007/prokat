import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EquipmentIdScreen extends StatelessWidget {
  final String equipmentId;
  const EquipmentIdScreen({super.key, required this.equipmentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 1. Animated Header with Main Photo
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                equipmentId.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Image.network(
                "https://picsum.photos/200",
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. Machine Specs & Details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$450/day",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      Chip(
                        label: Text("Available"),
                        backgroundColor: Colors.greenAccent,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Technical Specifications",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  _buildSpecRow(
                    Icons.settings_input_component,
                    "Engine Power",
                    "157 HP",
                  ),
                  _buildSpecRow(
                    Icons.fitness_center,
                    "Operating Weight",
                    "22,500 kg",
                  ),
                  _buildSpecRow(Icons.shutter_speed, "Max Speed", "5.5 km/h"),
                  _buildSpecRow(
                    Icons.location_on,
                    "Current Location",
                    "Atyrau, KZ",
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Description",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "This heavy-duty loader is perfect for large-scale earthmoving. Features fuel-efficient engine and ergonomic cabin for long shifts.",
                    style: TextStyle(color: Colors.grey, height: 1.5),
                  ),
                  const SizedBox(height: 100), // Space for bottom button
                ],
              ),
            ),
          ),
        ],
      ),

      // 3. Persistent Booking Button
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            context.push('/equipment/$equipmentId/book');
          },
          child: const Text(
            "BOOK THIS MACHINE",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: Colors.grey)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
