import 'package:flutter/material.dart';

class RequestStatusBadge extends StatelessWidget {
  final String status;

  const RequestStatusBadge({super.key, required this.status});

  Color get color {
    switch (status) {
      case "CREATED":
        return Colors.blue;
      case "VIEWED":
        return Colors.orange;
      case "ACCEPTED":
        return Colors.green;
      case "CANCELLED":
        return Colors.red;
      case "EXPIRED":
        return Colors.grey;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
