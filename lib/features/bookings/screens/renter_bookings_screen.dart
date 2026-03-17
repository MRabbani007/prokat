import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/core/widgets/page_header.dart';
import 'package:prokat/features/bookings/state/booking_provider.dart';
import 'package:prokat/features/bookings/widgets/booking_card.dart';

// Assume you already have these
// bookingProvider -> handles fetching bookings
// BookingModel -> has status + equipmentId + isDraft flag
class RenterBookingsScreen extends ConsumerStatefulWidget {
  const RenterBookingsScreen({super.key});

  @override
  ConsumerState<RenterBookingsScreen> createState() =>
      _RenterBookingsScreenState();
}

class _RenterBookingsScreenState extends ConsumerState<RenterBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Fetch every time screen opens
    Future.microtask(() {
      ref.read(bookingProvider.notifier).getBookings();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await ref.read(bookingProvider.notifier).getBookings();
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingProvider);
    final upcoming = bookingState.bookings
        .where((b) => b.status == "CREATED" || b.status == "CONFIRMED")
        .toList();

    final history = bookingState.bookings
        .where((b) => b.status == "COMPLETED" || b.status == "CANCELLED")
        .toList();

    final draft = bookingState.bookings
        .where((b) => b.status == "DRAFT")
        .toList();

    return Scaffold(
      backgroundColor: Colors.grey[100], // Soft background
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageHeader(title: "My Bookings"),
            // 1. Balanced Header (Accounts for top-left FAB)
            // Padding(
            //   padding: const EdgeInsets.only(
            //     top: 12,
            //     left: 90,
            //     right: 20,
            //     bottom: 20,
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         'My Bookings',
            //         style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            //           fontWeight: FontWeight.bold,
            //           color: Colors.black87,
            //         ),
            //       ),
            //       Text(
            //         'Track your rentals and history',
            //         style: TextStyle(color: Colors.grey[600], fontSize: 14),
            //       ),
            //     ],
            //   ),
            // ),

            // 2. High-Priority Draft Card
            if (draft.isNotEmpty) _EnhancedDraftCard(booking: draft.first),

            // 3. Modern Segmented TabBar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey[600],
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(text: 'Upcoming'),
                  Tab(text: 'History'),
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

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            'My Bookings',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
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
              Icons.calendar_today_outlined,
              size: 60,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'No bookings found',
              style: TextStyle(color: Colors.grey[500], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: bookings.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange[400]!, Colors.orange[600]!],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.shopping_cart_checkout, color: Colors.white),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Finish your booking request',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () =>
                context.push('/equipment/${booking.equipmentId}/book'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.orange[700],
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Resume'),
          ),
        ],
      ),
    );
  }
}

class _DraftBanner extends StatelessWidget {
  final dynamic booking;

  const _DraftBanner({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded),
          const SizedBox(width: 10),
          const Expanded(child: Text('You have an unfinished booking')),
          TextButton(
            onPressed: () {
              context.push('/equipment/${booking.equipmentId}/book');
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}
