import 'package:flutter/material.dart';
import 'package:prokat/features/bookings/models/booking_model.dart';

class UserBookingTile extends StatelessWidget {
  final BookingModel booking;
  const UserBookingTile({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;

    final displayUrl = booking.equipment.imageUrl ?? "";

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // CRITICAL: Hugs contents
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatusBadge(status: booking.status),
              Text(
                "${booking.price} ₸",
                style: TextStyle(
                  color: accent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              SizedBox(
                width: 130, // Fixed width
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      displayUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.image),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Info Section
              Expanded(
                // Horizontal expansion only
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.equipment.name,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _infoRow(Icons.location_on, booking.location.street),
                    const SizedBox(height: 4),
                    _infoRow(
                      Icons.access_time,
                      "Today 12:00",
                    ), // Simple date for testing
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: _actionButton(Icons.chat, Colors.green, () {}),
              ),

              const SizedBox(width: 8),

              // Expanded(child: _actionButton(Icons.visibility, accent, () {})),

              // const SizedBox(width: 8),

              Expanded(
                child: _actionButton(Icons.close, Colors.redAccent, () {}),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Icon(icon, size: 24, color: color),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
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
      case 'CREATED':
        baseColor = Colors.orange;
        break;
      case 'CONFIRMED':
        baseColor = Colors.green;
        break;
      case 'COMPLETED':
        baseColor = Color(0xFF4E73DF);
        break;
      case 'CANCELLED':
        baseColor = Colors.red;
        break;
      default:
        baseColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: baseColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: baseColor.withValues(alpha: 0.6), width: 1),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: baseColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
