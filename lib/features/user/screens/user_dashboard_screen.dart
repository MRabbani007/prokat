import 'package:flutter/material.dart';

class UserDashboardPage extends StatelessWidget {
  const UserDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFF121212);
    final card = const Color(0xFF1E1E1E);
    final accent = const Color(0xFFFFB300); // industrial amber

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(card, accent),
            const SizedBox(height: 12),
            _buildStatsRow(card, accent),
            const SizedBox(height: 16),
            _buildCategories(accent),
            const SizedBox(height: 16),
            Expanded(child: _buildEquipmentList(card, accent)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color card, Color accent) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 28, backgroundColor: accent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Mohamad",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text("4.2", style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: const [
              Icon(Icons.pin_drop, color: Colors.white),
              SizedBox(height: 4),
              Text("Atryau", style: TextStyle(color: Colors.white70)),
            ],
          ),
          const SizedBox(width: 16),
          Row(
            children: const [
              Icon(Icons.language, color: Colors.white),
              SizedBox(height: 4),
              Text("EN", style: TextStyle(color: Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(Color card, Color accent) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          _statCard("Active Rentals", "3", card, accent),
          const SizedBox(width: 10),
          _statCard("Pending", "1", card, accent),
          const SizedBox(width: 10),
          _statCard("Completed", "12", card, accent),
        ],
      ),
    );
  }

  Widget _statCard(String title, String value, Color card, Color accent) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: accent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories(Color accent) {
    final categories = ["Septic Trucks", "Forklifts", "Cranes", "Boom Trucks"];

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Container(
            width: 100,
            margin: const EdgeInsets.only(left: 12),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.construction, color: accent),
                const SizedBox(height: 6),
                Text(
                  categories[index],
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEquipmentList(Color card, Color accent) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: card,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.fire_truck, color: Colors.white54),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Septic Truck",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Available • 2km away",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Text("\$120/day", style: TextStyle(color: accent, fontSize: 14)),
            ],
          ),
        );
      },
    );
  }
}
