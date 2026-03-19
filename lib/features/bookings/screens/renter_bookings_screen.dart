import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/core/widgets/page_header.dart';
import 'package:prokat/features/bookings/state/booking_provider.dart';
import 'package:prokat/features/bookings/widgets/booking_card.dart';

class RenterBookingsScreen extends ConsumerStatefulWidget {
  const RenterBookingsScreen({super.key});

  @override
  ConsumerState<RenterBookingsScreen> createState() =>
      _RenterBookingsScreenState();
}

class _RenterBookingsScreenState extends ConsumerState<RenterBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Theme Constants
  final bgColor = const Color(0xFF121417);
  final accentColor = const Color(0xFF4E73DF);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(
      () => ref.read(bookingProvider.notifier).getUserBookings(),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingProvider);

    final upcoming = bookingState.bookings
        .where((b) => b.status == "CREATED" || b.status == "CONFIRMED")
        .toList();

    final history = bookingState.bookings
        .where(
          (b) =>
              b.status == "COMPLETED" ||
              b.status == "CANCELLED" ||
              b.status == "REJECTED",
        )
        .toList();

    final draft = bookingState.bookings
        .where((b) => b.status == "DRAFT")
        .toList();

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageHeader(title: "My Rentals"),

            // 1. High-Priority Draft Card (Refined Orange)
            if (draft.isNotEmpty) _EnhancedDraftCard(booking: draft.first),

            // 2. Industrial Segmented TabBar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: const Color(
                    0xFF1E2125,
                  ), // Lighter charcoal for active tab
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white.withValues(alpha: 0.3),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
                tabs: const [
                  Tab(text: 'UPCOMING'),
                  Tab(text: 'HISTORY'),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _BookingList(bookings: upcoming),
                  _BookingList(bookings: history),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingList extends StatelessWidget {
  final List bookings;
  const _BookingList({required this.bookings});

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 48,
              color: Colors.white.withValues(alpha: 0.05),
            ),
            const SizedBox(height: 16),
            Text(
              'No bookings found',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.2),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      itemCount: bookings.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return BookingCard(booking: booking);
      },
    );
  }
}

class _EnhancedDraftCard extends StatelessWidget {
  final dynamic booking;
  const _EnhancedDraftCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    const draftColor = Color(0xFFD97706); // Industrial Amber

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: draftColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: draftColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: draftColor, size: 20),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DRAFT INCOMPLETE',
                  style: TextStyle(
                    color: draftColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  'Finish your booking request',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () =>
                context.push('/equipment/${booking.equipmentId}/book'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: draftColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              'RESUME',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
