import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/bookings/state/booking_provider.dart';
import 'package:prokat/features/user/widgets/user_booking_tile.dart';

class ClientBookingsSection extends ConsumerStatefulWidget {
  const ClientBookingsSection({super.key});

  @override
  ConsumerState<ClientBookingsSection> createState() =>
      _ClientBookingsSectionState();
}

class _ClientBookingsSectionState extends ConsumerState<ClientBookingsSection> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bookingProvider.notifier).getUserBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingProvider);

    final upcoming = bookingState.bookings
        .where((b) => b.status == "CREATED" || b.status == "CONFIRMED")
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Active Orders",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),

        // Uncommented and simplified
        Column(
          children: upcoming
              .map((booking) => UserBookingTile(booking: booking))
              .toList(),
        ),
      ],
    );
  }
}
