import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/core/widgets/page_header.dart';
import 'package:prokat/features/bookings/state/booking_provider.dart';
import 'package:prokat/features/bookings/widgets/owner_booking_card.dart';
import 'package:go_router/go_router.dart';

class OwnerBookingHistoryScreen extends ConsumerStatefulWidget {
  const OwnerBookingHistoryScreen({super.key});

  @override
  ConsumerState<OwnerBookingHistoryScreen> createState() => _OwnerBookingHistoryScreenState();
}

class _OwnerBookingHistoryScreenState extends ConsumerState<OwnerBookingHistoryScreen> {
  final bgColor = const Color(0xFF121417);
  final ghostGray = const Color(0x4DFFFFFF);

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingProvider);
    
    // Filter for non-active states
    final history = state.bookings
        .where((b) => b.status == "COMPLETED" || b.status == "CANCELLED" || b.status == "REJECTED")
        .toList();

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Technical Header
            _HistoryHeader(onBack: () => context.pop()),

            // 2. Search / Filter Bar (Mockup for technical feel)
            _SearchFilterBar(),

            Expanded(
              child: history.isEmpty 
                ? _EmptySystemState() // Reusing the standby state we built
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final booking = history[index];
                      // Use the same card but wrapped in an "Archived" styling
                      return Opacity(
                        opacity: 0.8, // Slightly dimmed to show it's past data
                        child: OwnerBookingCard(booking: booking),
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryHeader extends StatelessWidget {
  final VoidCallback onBack;
  const _HistoryHeader({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
        ),
        const Expanded(child: PageHeader(title: "Booking History")),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Icon(Icons.archive_outlined, color: Colors.white.withValues(alpha: 0.1), size: 24),
        ),
      ],
    );
  }
}

class _SearchFilterBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2125),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: Color(0x4DFFFFFF), size: 18),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "SEARCH ARCHIVED LOGS...",
              style: TextStyle(color: Color(0x4DFFFFFF), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2),
            ),
          ),
          Icon(Icons.tune_rounded, color: Colors.white.withValues(alpha: 0.4), size: 18),
        ],
      ),
    );
  }
}

class _EmptySystemState extends StatelessWidget {
  const _EmptySystemState();

  @override
  Widget build(BuildContext context) {
    const ghostGray = Color(0x4DFFFFFF); // White @ 30%

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // "Dimmed" System Icon
          Icon(
            Icons.sensors_off_rounded,
            size: 48,
            color: Colors.white.withValues(alpha: 0.05),
          ),
          const SizedBox(height: 24),

          // Terminal-style text
          const Text(
            "SYSTEM STANDBY",
            style: TextStyle(
              color: ghostGray,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 8),

          const Text(
            "No active deployments or pending requests located in the fleet database.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white24, fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }
}
