import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prokat/features/bookings/models/booking_model.dart'; // For better date/time formatting

class BookingCard extends StatelessWidget {
  final BookingModel booking; // Replace with your BookingModel

  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withAlpha(20), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // Top Section: Equipment & Status
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "${booking.equipmentName} ${booking.equipmentName}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1C1E),
                          ),
                        ),
                      ),
                      _StatusBadge(status: booking.status),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Capacity: 10 M3",//${booking.capacity} ${booking.capacityUnit}",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const Divider(height: 24, thickness: 0.5),
                  
                  // Location Row
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16, color: Colors.blueAccent),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Satpayeva, Atyrau",
                          // "${booking.street}, ${booking.city}",
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Date/Time Row
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(
                        booking.bookedOn != null 
                          ? DateFormat('MMM dd, yyyy • hh:mm a').format(booking.bookedOn ?? DateTime(0))
                          : "Date not set",
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Bottom Section: Pricing (Different Background)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.grey[50],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total Price",
                    style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "\$${booking.price} ",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        TextSpan(
                          text: "/ ${booking.priceRate}",
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color baseColor;
    switch (status.toUpperCase()) {
      case 'CREATED': baseColor = Colors.orange; break;
      case 'CONFIRMED': baseColor = Colors.green; break;
      case 'COMPLETED': baseColor = Colors.blue; break;
      case 'CANCELLED': baseColor = Colors.red; break;
      default: baseColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: baseColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: baseColor.withOpacity(0.5), width: 1),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: baseColor,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
