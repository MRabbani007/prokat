import 'package:flutter/material.dart';

class OwnerChatScreen extends StatelessWidget {
  final String? chatId;
  final bool isOrderCompleted; // Logic to disable input if closed

  const OwnerChatScreen({
    super.key,
    this.isOrderCompleted = false,
    this.chatId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("John Doe", style: TextStyle(fontSize: 16)),
            Text("Online", style: TextStyle(fontSize: 12, color: Colors.green)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              /* Navigate to Info Screen */
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildOrderContextCard(),
                const Center(
                  child: Text(
                    "Chat started on Oct 12",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                _buildMessageBubble(
                  message: "Is the equipment ready?",
                  isMe: false,
                ),
                _buildMessageBubble(
                  message: "Yes, it is serviced and ready for pickup.",
                  isMe: true,
                ),
              ],
            ),
          ),
          if (isOrderCompleted) _buildClosedChatBanner() else _buildChatInput(),
        ],
      ),
    );
  }

  Widget _buildOrderContextCard() {
    return Card(
      color: Colors.blue.shade50,
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              color: Colors.blue.shade200,
              child: const Icon(Icons.construction),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Excavator X100",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("Oct 14 - Oct 18 • 4 Days"),
                  Text("\$450.00 Total", style: TextStyle(color: Colors.blue)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble({required String message, required bool isMe}) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message,
          style: TextStyle(color: isMe ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Widget _buildClosedChatBanner() {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade100,
      padding: const EdgeInsets.all(16),
      child: const Text(
        "This order is completed. Chat is read-only.",
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildChatInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Type a message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
