import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:prokat/features/bookings/models/booking_model.dart';
import 'package:prokat/features/bookings/state/booking_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/features/bookings/widgets/owner_booking_card.dart';
import 'package:lucide_icons/lucide_icons.dart';

class OwnerBookingsScreen extends ConsumerStatefulWidget {
  const OwnerBookingsScreen({super.key});

  @override
  ConsumerState<OwnerBookingsScreen> createState() =>
      _OwnerBookingsScreenState();
}

class _OwnerBookingsScreenState extends ConsumerState<OwnerBookingsScreen> {
  // final bgColor = const Color(0xFF121417);
  // final accentBlue = const Color(0xFF4E73DF);
  // final amberWarning = const Color(0xFFD97706);
  // final ghostGray = const Color(0x4DFFFFFF);

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(bookingProvider.notifier).getOwnerBookings(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // 1. Header with Archive Button
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(LucideIcons.chevronLeft, size: 25),
                      onPressed: () => context.canPop() ? context.pop() : null,
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                      padding: EdgeInsets.zero,
                    ),

                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 48.0),
                        child: Text(
                          "My Orders",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ),
                    // Small technical Archive button
                    IconButton(
                      onPressed: () => context.push('/owner/bookings/history'),
                      icon:  Icon(
                        Icons.history_toggle_off_rounded,
                        color: theme.colorScheme.secondary,
                        size: 24,
                      ),
                      tooltip: "Job History",
                    ),
                  ],
                ),
              ),

              // 2. Owner Industrial Segmented TabBar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                height: 48,
                decoration: BoxDecoration(
                  color: theme.textTheme.bodyMedium?.color,
                  borderRadius: BorderRadius.circular(14), // Small Item Radius
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: theme.colorScheme.outline,
                  indicator: BoxDecoration(
                    color: theme.colorScheme.primary, // Industrial Charcoal
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  labelColor: theme.colorScheme.onPrimary,
                  unselectedLabelColor: theme.colorScheme.onSecondary, // Ghost Gray
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
  final BookingModel booking;
  final bool isNew;

  const _SwipeableBookingCard({required this.booking, required this.isNew});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

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
                      backgroundColor: theme.primaryColor.withValues(
                        alpha: 0.2,
                      ),
                      foregroundColor: theme.colorScheme.onPrimary,
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
