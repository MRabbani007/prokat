import 'package:flutter/material.dart';

class OwnerChatListScreen extends StatelessWidget {

  const OwnerChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Orders & Messages"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Active"),
              Tab(text: "Completed"),
              Tab(text: "Archived"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildChatList(status: "active"),
            _buildChatList(status: "completed"),
            _buildChatList(status: "archived"),
          ],
        ),
      ),
    );
  }

  Widget _buildChatList({required String status}) {
    return ListView.separated(
      itemCount: 5, // Replace with dynamic data
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        return ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: const Text("John Doe"),
          subtitle: Text("Excavator X100 • #ORD-882$index"),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text("10:45 AM", style: TextStyle(fontSize: 12)),
              if (status == "active") 
                const Badge(label: Text("2")),
            ],
          ),
          onTap: () {
            // Navigate to IndividualChatScreen
          },
        );
      },
    );
  }
}
