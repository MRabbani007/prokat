import 'package:flutter/material.dart';

class BookingStatusBadge extends StatelessWidget {
  final String status;
  
  const BookingStatusBadge({
    super.key, 
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    Color statusColor;
    switch (status.toUpperCase()) {
      case 'CREATED':
        statusColor = colors.tertiary;
        break;
      case 'CONFIRMED':
        statusColor = colors.primary;
        break;
      case 'COMPLETED':
        statusColor = colors.secondary;
        break;
      default:
        statusColor = colors.outline;
    }

    return Container(
      decoration: BoxDecoration(
        // 1. SOLID BASE: This stops color mixing/bleeding from the tile
        color: theme.cardColor, // Usually white or your theme's surface color
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        // 2. OVERLAY: The low-alpha status color on top of the solid base
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: statusColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: statusColor.withValues(alpha: 0.25),
            width: 1,
          ),
        ),
        child: Text(
          status.toUpperCase(),
          style: TextStyle(
            color: statusColor,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
