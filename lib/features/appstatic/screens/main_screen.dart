import 'package:flutter/material.dart';
import 'package:prokat/features/appstatic/widgets/categories_grid.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: "Search excavators, lifts...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: const Icon(Icons.tune),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 24),

            // Categories
            const SectionHeader(title: "Categories"),

            const SizedBox(height: 12),

            const CategoriesGrid(),

            // SizedBox(
            //   height: 100,
            //   child: ListView(
            //     scrollDirection: Axis.horizontal,
            //     children: const [
            //       CategoryCard(icon: Icons.agriculture, label: "Tractors"),
            //       CategoryCard(icon: Icons.handyman, label: "Lifts"),
            //       CategoryCard(icon: Icons.construction, label: "Excavators"),
            //       CategoryCard(icon: Icons.bolt, label: "Generators"),
            //     ],
            //   ),
            // ),
            const SizedBox(height: 24),

            // Featured Equipment
            const SectionHeader(title: "Featured Near You"),
            const SizedBox(height: 12),
            const EquipmentCard(
              name: "Caterpillar 320 Excavator",
              price: "\$450/day",
              imageUrl: "assets/images/categories/septic_truck.jpg",
              rating: "4.8",
            ),
            const EquipmentCard(
              name: "JLG 450AJ Boom Lift",
              price: "\$220/day",
              imageUrl: "assets/images/categories/septic_truck.jpg",
              rating: "4.5",
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable Components
class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.blue),
        ),
        TextButton(onPressed: () {}, child: const Text("View All")),
      ],
    );
  }
}

class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  const CategoryCard({super.key, required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.orange.withAlpha(10),
            child: Icon(icon, color: Colors.orange),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class EquipmentCard extends StatelessWidget {
  final String name, price, imageUrl, rating;
  const EquipmentCard({
    super.key,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.rating,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(16),
            ),
            child: Image.asset(
              imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    price,
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(" $rating", style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
