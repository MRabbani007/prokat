import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prokat/features/bookings/models/booking_model.dart';

class BookingCard extends StatelessWidget {
  final BookingModel booking;

  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFF1E2125);
    const accentColor = Color(0xFF4E73DF);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // 1. Top Section: Primary Details
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
                          booking.equipment.name, // ?? 'Unknown Equipment',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      _StatusBadge(status: booking.status),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "CAPACITY: 10 M3", // Hardcoded per your snippet
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(height: 1, thickness: 1, color: Colors.white10),
                  ),
                  
                  // Meta Info Grid
                  _buildMetaRow(
                    Icons.location_on_outlined, 
                    "Satpayeva, Atyrau", 
                    accentColor,
                  ),
                  const SizedBox(height: 12),
                  _buildMetaRow(
                    Icons.calendar_today_outlined,
                    booking.bookedOn != null 
                        ? DateFormat('MMM dd, yyyy • hh:mm a').format(booking.bookedOn!)
                        : "Date not set",
                    Colors.orangeAccent,
                  ),
                ],
              ),
            ),

            // 2. Bottom Section: Pricing Action Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.02),
                border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "TOTAL PRICE",
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      color: Colors.white.withValues(alpha: 0.3),
                      fontSize: 10,
                      letterSpacing: 1.2,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "${booking.price} ₸ ", // Switched to Tenge symbol for consistency
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: accentColor,
                          ),
                        ),
                        TextSpan(
                          text: "/ ${booking.priceRate}",
                          style: TextStyle(
                            fontSize: 12, 
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
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

  Widget _buildMetaRow(IconData icon, String text, Color iconColor) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 14, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: Colors.white70, fontWeight: FontWeight.w500),
          ),
        ),
      ],
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
      case 'CONFIRMED': baseColor = Colors.greenAccent; break;
      case 'COMPLETED': baseColor = Color(0xFF4E73DF); break;
      case 'CANCELLED': baseColor = Colors.redAccent; break;
      default: baseColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: baseColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: baseColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: baseColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
