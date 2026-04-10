import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:prokat/core/router/app_routes.dart';
import 'package:prokat/features/bookings/models/booking_model.dart';
import 'package:prokat/features/bookings/models/work_status.dart';
import 'package:prokat/features/bookings/state/booking_provider.dart';
import 'package:prokat/features/bookings/widgets/booking_status_badge.dart';
import 'package:go_router/go_router.dart';

// enum WorkStatus {
//   idle,
//   onMyWay,
//   onSite,
//   started,
//   completed,

//   // failure cases
//   clientNoShow,
//   wrongAddress,
//   notAccessible,
//   placeNotReady,
//   missingTools,
//   stopped,
//   postponed,
//   cancelled,
// }

class OwnerBookingCard extends ConsumerWidget {
  final BookingModel booking;

  const OwnerBookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final temp = booking.priceRate.toUpperCase();
    final priceRate = temp == "PER_TRIP"
        ? "/ Trip"
        : temp == "PER_CUBIC_METER"
        ? "/ M3"
        : temp == "PER_HOUR"
        ? "/ Hour"
        : "";

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
                    color: colors.surface,
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
                        "REQUESTED BY",
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 130, // Fixed width
                      child: AspectRatio(
                        aspectRatio: 4 / 3,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            booking.equipment.imageUrl ?? "",
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

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.equipment.name.toUpperCase(),
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 16),

                        _TechMetaRow(
                          Icons.calendar_today_rounded,
                          null,
                          // "SCHEDULED",
                          booking.bookedOn != null
                              ? DateFormat(
                                  'dd MMM yyyy • HH:mm',
                                ).format(booking.bookedOn!)
                              : "PENDING",
                        ),
                        const SizedBox(height: 12),

                        _TechMetaRow(
                          Icons.location_on_rounded,
                          null,
                          // "Address",
                          booking.location.street,
                        ),
                      ],
                    ),
                  ],
                ),

                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Price",
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colors.onSurface.withValues(alpha: 0.6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "${booking.price} ₸",
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              priceRate,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// FOOTER
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: colors.surface.withValues(alpha: 0.4),
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
                // Cancel order
                _ActionButton(
                  icon: Icons.close_rounded,
                  color: theme.colorScheme.error,
                  onPressed: () {
                    _handleCancel(context, ref, booking);
                    // notifier.updateOrderStatus(booking.id, "on_my_way");
                  },
                ),

                const SizedBox(width: 8),

                // 💬 Chat
                _ActionButton(
                  icon: Icons.chat_bubble_outline_rounded,
                  color: theme.colorScheme.secondary,
                  onPressed: () {
                    context.push("${AppRoutes.ownerChatList}/${booking.id}");
                  },
                ),

                const SizedBox(width: 8),

                // 🟢 Start (Primary)
                Expanded(
                  child: _PrimaryActionButton(
                    label: "Start",
                    onPressed: () {
                      _openWorkFlowSheet(context, ref, booking);
                    },
                  ),
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
  final String? label;
  final String value;

  const _TechMetaRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      children: [
        Icon(icon, size: 24, color: colors.primary),

        const SizedBox(width: 12),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label != null)
              Text(
                label ?? "",
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

class _PrimaryActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _PrimaryActionButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 48,
            alignment: Alignment.center,
            child: Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 48,
            width: 48,
            child: Icon(icon, color: color, size: 20),
          ),
        ),
      ),
    );
  }
}

Future<void> _handleCancel(
  BuildContext context,
  WidgetRef ref,
  BookingModel booking,
) async {
  final theme = Theme.of(context);
  final notifier = ref.read(bookingProvider.notifier);

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Cancel Booking", style: theme.textTheme.titleMedium),
        content: Text(
          "Are you sure you want to cancel this order?",
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Yes, Cancel"),
          ),
        ],
      );
    },
  );

  if (confirmed != true) return;

  // ⏱️ Time restriction check
  final createdAt = booking.createdAt ?? DateTime(2026);
  final now = DateTime.now();

  const cancelWindowMinutes = 10;

  final difference = now.difference(createdAt).inMinutes;

  if (difference < cancelWindowMinutes) {
    final res = await notifier.updateBookingStatus(
      booking.id,
      "CANCELLED",
      "cancelled in $difference minutes",
    );

    if (res == true) {
      Navigator.pop(context); // close sheet

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Order Cancelled")));
    }
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text(
    //       "You can only cancel within $cancelWindowMinutes minutes of booking.",
    //     ),
    //   ),
    // );
    return;
  }

  // Open reason sheet
  _showCancelSheet(context, ref, booking);
}

void _showCancelSheet(
  BuildContext context,
  WidgetRef ref,
  BookingModel booking,
) {
  final theme = Theme.of(context);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: theme.colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return _CancelReasonSheet(booking: booking);
    },
  );
}

class _CancelReasonSheet extends ConsumerStatefulWidget {
  final BookingModel booking;

  const _CancelReasonSheet({required this.booking});

  @override
  ConsumerState<_CancelReasonSheet> createState() => _CancelReasonSheetState();
}

class _CancelReasonSheetState extends ConsumerState<_CancelReasonSheet> {
  String? selectedReason;

  final reasons = [
    "Client did not respond",
    "Equipment unavailable",
    "Pricing issue",
    "Scheduling conflict",
    "Other",
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final notifier = ref.read(bookingProvider.notifier);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Text("Cancel Booking", style: theme.textTheme.titleMedium),

          const SizedBox(height: 16),

          ...reasons.map((reason) {
            final isSelected = selectedReason == reason;

            return GestureDetector(
              onTap: () {
                setState(() => selectedReason = reason);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary.withValues(alpha: 0.1)
                      : theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(reason, style: theme.textTheme.bodyMedium),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle,
                        color: theme.colorScheme.primary,
                        size: 18,
                      ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 12),

          // Confirm button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: selectedReason == null
                  ? null
                  : () async {
                      final res = await notifier.updateBookingStatus(
                        widget.booking.id,
                        "CANCELLED",
                        selectedReason,
                      );

                      if (res == true) {
                        Navigator.pop(context); // close sheet

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Order Cancelled")),
                        );
                      }

                      // Navigator.pop(
                      //   context,
                      // ); // optional: close dialog if still open
                    },
              child: const Text("Confirm Cancellation"),
            ),
          ),

          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Go Back"),
          ),
        ],
      ),
    );
  }
}

void _openWorkFlowSheet(
  BuildContext context,
  WidgetRef ref,
  BookingModel booking,
) {
  final theme = Theme.of(context);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: theme.colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => WorkStatusSheet(booking: booking),
  );
}

class WorkStatusSheet extends ConsumerWidget {
  final BookingModel booking;

  const WorkStatusSheet({super.key, required this.booking});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notifier = ref.read(bookingProvider.notifier);

    final currentStatus = booking.workStatus; //booking.workStatus;
    final isStarted = currentStatus.level >= WorkStatus.started.level;

    final availableStatuses = isStarted
        ? [WorkStatus.stopped, WorkStatus.completed, WorkStatus.cancelled]
        : [
            WorkStatus.onMyWay,
            WorkStatus.onSite,
            WorkStatus.started,
            WorkStatus.postponed,
          ];

    final validStatuses = availableStatuses
        .where((s) => canTransition(currentStatus, s))
        .toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Text("Update Work Status", style: theme.textTheme.titleMedium),

            const SizedBox(height: 16),

            ...validStatuses.map((status) {
              return _StatusTile(
                status: status,
                isCurrent: status == currentStatus,
                isDanger:
                    status == WorkStatus.cancelled ||
                    status == WorkStatus.stopped,
                onTap: () async {
                  // Update backend & send notification to client
                  await notifier.updateWorkStatus(booking.id, status.name);

                  // 3. Close sheet
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _StatusTile extends StatelessWidget {
  final WorkStatus status;
  final VoidCallback onTap;
  final bool isDanger;
  final bool isCurrent;

  const _StatusTile({
    required this.status,
    required this.onTap,
    this.isDanger = false,
    this.isCurrent = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final color = isDanger
        ? theme.colorScheme.error
        : theme.colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCurrent
                ? color.withValues(alpha: 0.3)
                : color.withValues(alpha: 0.7),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(status.label, style: theme.textTheme.bodyMedium),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: color.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }
}
