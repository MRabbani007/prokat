import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:prokat/core/widgets/page_header.dart';
import 'package:prokat/features/bookings/state/booking_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/features/bookings/widgets/owner_booking_card.dart';

class OwnerBookingsScreen extends ConsumerStatefulWidget {
  const OwnerBookingsScreen({super.key});

  @override
  ConsumerState<OwnerBookingsScreen> createState() =>
      _OwnerBookingsScreenState();
}

class _OwnerBookingsScreenState extends ConsumerState<OwnerBookingsScreen> {
  final bgColor = const Color(0xFF121417);
  final accentBlue = const Color(0xFF4E73DF);
  final amberWarning = const Color(0xFFD97706);
  final ghostGray = const Color(0x4DFFFFFF);

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(bookingProvider.notifier).getOwnerBookings(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingProvider);

    // Logic: Split into actionable categories
    final newRequests = state.ownerBookings
        .where((b) => b.status == "CREATED")
        .toList();
    final upcomingJobs = state.ownerBookings
        .where((b) => b.status == "CONFIRMED")
        .toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Column(
            children: [
              // 1. Header with Archive Button
              _OwnerHeader(
                onArchiveTap: () => context.push('/owner/bookings/history'),
              ),

              // 2. Owner Industrial Segmented TabBar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(14), // Small Item Radius
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: const Color(0xFF1E2125), // Industrial Charcoal
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white.withValues(
                    alpha: 0.3,
                  ), // Ghost Gray
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1.0,
                  ),
                  tabs: [
                    Tab(text: "NEW (${newRequests.length})"),
                    Tab(text: "UPCOMING (${upcomingJobs.length})"),
                  ],
                ),
              ),

              // 3. Tab Views
              Expanded(
                child: TabBarView(
                  children: [
                    _OwnerBookingList(
                      bookings: newRequests,
                      isNew: true,
                      emptyLabel: "NO PENDING REQUESTS",
                    ),
                    _OwnerBookingList(
                      bookings: upcomingJobs,
                      isNew: false,
                      emptyLabel: "NO ACTIVE DEPLOYMENTS",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OwnerHeader extends StatelessWidget {
  final VoidCallback onArchiveTap;
  const _OwnerHeader({required this.onArchiveTap});
 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(child: PageHeader(title: "Bookings")),
          // Small technical Archive button
          IconButton(
            onPressed: onArchiveTap,
            icon: const Icon(
              Icons.history_toggle_off_rounded,
              color: Color(0x4DFFFFFF),
              size: 24,
            ),
            tooltip: "Job History",
          ),
        ],
      ),
    );
  }
}

class _OwnerBookingList extends StatelessWidget {
  final List bookings;
  final bool isNew;
  final String emptyLabel;

  const _OwnerBookingList({
    required this.bookings,
    required this.isNew,
    required this.emptyLabel,
  });

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return Center(child: _EmptySystemState()); // Your custom empty state
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return _SwipeableBookingCard(booking: bookings[index], isNew: isNew);
      },
    );
  }
}

class _SwipeableBookingCard extends ConsumerWidget {
  final dynamic booking;
  final bool isNew;

  const _SwipeableBookingCard({required this.booking, required this.isNew});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(bookingProvider.notifier);
    final isLoading = ref.watch(bookingProvider).isLoading;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Slidable(
          // Accept Action
          startActionPane: isNew
              ? ActionPane(
                  motion: const DrawerMotion(),
                  extentRatio: 0.3,
                  children: [
                    SlidableAction(
                      // Logic to CONFIRM
                      onPressed: isLoading
                          ? null
                          : (_) async {
                              await notifier.updateBooking(booking.id, {
                                'status': 'CONFIRMED',
                                'id': booking.id,
                              });
                            },
                      backgroundColor: const Color(
                        0xFF4E73DF,
                      ).withValues(alpha: 0.2),
                      foregroundColor: const Color(0xFF4E73DF),
                      icon: Icons.check_circle_outline,
                      label: 'ACCEPT',
                    ),
                  ],
                )
              : null,
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: 0.3,
            children: [
              SlidableAction(
                // Reject Action
                onPressed: isLoading
                    ? null
                    : (_) async {
                        await notifier.updateBooking(booking.id, {
                          'status': 'REJECTED',
                          'id': booking.id,
                        });
                      }, // Logic to REJECT/CANCEL
                backgroundColor: const Color(0xFFD97706).withValues(alpha: 0.1),
                foregroundColor: const Color(0xFFD97706),
                icon: Icons.close_rounded,
                label: isNew ? 'REJECT' : 'CLOSE',
              ),
            ],
          ),
          child: OwnerBookingCard(
            booking: booking,
          ), // Existing card styled midnight
        ),
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
