import 'package:flutter/material.dart';

class OwnerChatInfoScreen extends StatelessWidget {
  const OwnerChatInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order Details")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInfoSection("Booking Info", [
            const ListTile(title: Text("Order ID"), subtitle: Text("#ORD-8820")),
            const ListTile(title: Text("Status"), subtitle: Text("In Progress", style: TextStyle(color: Colors.orange))),
          ]),
          _buildInfoSection("Client Details", [
            const ListTile(title: Text("Name"), subtitle: Text("John Doe")),
            const ListTile(title: Text("Rating"), subtitle: Text("⭐ 4.9 (12 Rentals)")),
          ]),
          _buildInfoSection("Payment", [
            const ListTile(title: Text("Rental Fee"), subtitle: Text("\$400.00")),
            const ListTile(title: Text("Insurance"), subtitle: Text("\$50.00")),
            const ListTile(title: Text("Total Paid"), subtitle: Text("\$450.00", style: TextStyle(fontWeight: FontWeight.bold))),
          ]),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
            onPressed: () { /* Logic to complete job and close chat */ },
            child: const Text("Mark Job as Completed"),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        Card(child: Column(children: children)),
      ],
    );
  }
}
