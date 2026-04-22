import 'package:flutter/material.dart';
import 'package:prokat/core/utils/format.dart';

class BookingStatusBadge extends StatelessWidget {
  final String status;

  const BookingStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: getBookingColor(status).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: getBookingColor(status).withValues(alpha: 0.4),
        ),
      ),
      child: Text(
        getBookingStatus(status),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: getBookingColor(status),
        ),
      ),
    );
  }
}
