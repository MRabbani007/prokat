import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prokat/features/bookings/models/booking_model.dart';

class OwnerBookingCard extends StatelessWidget {
  final BookingModel booking;

  const OwnerBookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFF1E2125);
    const accentBlue = Color(0xFF4E73DF);
    // const amberWarning = Color(0xFFD97706);
    const ghostGray = Color(0x4DFFFFFF);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28), // Large Item Radius
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ), // Rim Light
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. HEADER: Renter & Status
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 16, 12),
            child: Row(
              children: [
                // Renter Avatar / Identifier
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                  child: const Icon(
                    Icons.person_pin_rounded,
                    color: accentBlue,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "REQUESTING ENTITY",
                        style: TextStyle(
                          color: ghostGray,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        booking.renter?.firstName ?? "USER",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                _IndustrialStatusBadge(status: booking.status),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 1, color: Colors.white10),

          // 2. BODY: Asset & Logistics
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ASSET: ${booking.equipment.name.toUpperCase()}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 16),

                // Technical Meta Grid
                _TechMetaRow(
                  Icons.calendar_today_rounded,
                  "SCHEDULED",
                  booking.bookedOn != null
                      ? DateFormat(
                          'dd MMM yyyy • HH:mm',
                        ).format(booking.bookedOn!)
                      : "PENDING",
                ),
                const SizedBox(height: 12),
                _TechMetaRow(
                  Icons.location_on_rounded,
                  "DEPLOYMENT",
                  booking.location.street, // ?? "ATYRAU REGION",
                ),
              ],
            ),
          ),

          // 3. FOOTER: Financials & Action
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2), // Recessed Panel
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(28),
              ),
              border: Border(
                top: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "TRANSACTION VALUE",
                      style: TextStyle(
                        color: ghostGray,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${booking.price} ₸",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
                // Swipe Indicator or Small Action Icon
                Icon(
                  Icons.swipe_vertical_rounded,
                  color: Colors.white.withValues(alpha: 0.1),
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TechMetaRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _TechMetaRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF4E73DF)),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Color(0x4DFFFFFF),
                fontSize: 8,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _IndustrialStatusBadge extends StatelessWidget {
  final String status;
  const _IndustrialStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status.toUpperCase()) {
      case 'CREATED':
        color = const Color(0xFFD97706);
        break; // Amber
      case 'CONFIRMED':
        color = const Color(0xFF4E73DF);
        break; // Blue
      case 'COMPLETED':
        color = Colors.white70;
        break;
      default:
        color = Colors.white24;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
