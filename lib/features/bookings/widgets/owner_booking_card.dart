import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prokat/features/bookings/models/booking_model.dart';
import 'package:prokat/features/bookings/widgets/booking_status_badge.dart';

class OwnerBookingCard extends StatelessWidget {
  final BookingModel booking;

  const OwnerBookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 16, 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colors.outline.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Icon(
                    Icons.person_pin_rounded,
                    color: colors.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "REQUESTING ENTITY",
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colors.onSurface.withValues(alpha: 0.6),
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        booking.renter?.firstName ?? "USER",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                BookingStatusBadge(status: booking.status),
              ],
            ),
          ),

          Divider(
            height: 1,
            thickness: 1,
            color: colors.outline.withValues(alpha: 0.1),
          ),

          /// BODY
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ASSET: ${booking.equipment.name.toUpperCase()}",
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 16),

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
                  booking.location.street,
                ),
              ],
            ),
          ),

          /// FOOTER
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: colors.surfaceVariant.withValues(alpha: 0.4),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(28),
              ),
              border: Border(
                top: BorderSide(color: colors.outline.withValues(alpha: 0.1)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "TRANSACTION VALUE",
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colors.onSurface.withValues(alpha: 0.6),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${booking.price} ₸",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.swipe_vertical_rounded,
                  color: colors.onSurface.withValues(alpha: 0.2),
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
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      children: [
        Icon(icon, size: 16, color: colors.primary),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colors.onSurface.withValues(alpha: 0.6),
                letterSpacing: 1,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurface.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}