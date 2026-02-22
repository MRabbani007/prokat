import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyRentalsScreen extends StatelessWidget {
  const MyRentalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: const TabBar(
            indicatorColor: Colors.orange,
            labelColor: Colors.orange,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: "Active"),
              Tab(text: "Upcoming"),
              Tab(text: "History"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildRentalList(status: "Active"),
            _buildRentalList(status: "Upcoming"),
            _buildRentalList(status: "Completed"),
          ],
        ),
      ),
    );
  }

  Widget _buildRentalList({required String status}) {
    // Mock data - replace with your API/Firebase stream
    final List<Map<String, String>> rentals = [
      {
        "id": "CAT-950L",
        "name": "Wheel Loader CAT 950L",
        "dates": "Oct 12 - Oct 20",
        "price": "\$3,600",
        "location": "Atyrau Refinery Site",
      },
    ];

    if (rentals.isEmpty) return const Center(child: Text("No rentals found"));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rentals.length,
      itemBuilder: (context, index) {
        final item = rentals[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.local_shipping, color: Colors.orange),
                ),
                title: Text(
                  item["name"]!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text("📅 ${item["dates"]}"),
                    Text("📍 ${item["location"]}"),
                  ],
                ),
                trailing: Text(
                  item["price"]!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const Divider(height: 0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (status == "Active")
                      TextButton(
                        onPressed: () {},
                        child: const Text("Extend Rental"),
                      ),
                    TextButton(
                      onPressed: () => context.push('/equipment/${item["id"]}'),
                      child: const Text("View Details"),
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
