import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/core/router/app_routes.dart';
import 'package:prokat/core/widgets/base_tile.dart';
import 'package:prokat/features/bookings/state/booking_provider.dart';
import 'package:prokat/features/bookings/widgets/owner_booking_card.dart';
import 'package:prokat/features/equipment/providers/equipment_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/features/requests/state/request_provider.dart';
import 'package:prokat/features/requests/widgets.dart/owner_booking_skeleton.dart';
import 'package:prokat/features/user/widgets/balance_tile.dart';
import 'package:prokat/features/user/widgets/owner_dashboard_header.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:prokat/features/user/widgets/rent_an_equipment_tile.dart';

class OwnerDashboardScreen extends ConsumerStatefulWidget {
  const OwnerDashboardScreen({super.key});

  @override
  ConsumerState<OwnerDashboardScreen> createState() =>
      _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends ConsumerState<OwnerDashboardScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(equipmentProvider.notifier).getOwnerEquipment();
      ref.read(requestProvider.notifier).getOwnerRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final activeRequests = ref
        .watch(requestProvider)
        .ownerRequests
        .where((r) => ["CREATED", "VIEWED"].contains(r.status))
        .toList();

    final equipment = ref.watch(equipmentProvider).ownerEquipment;

    final hasRequests = activeRequests.isNotEmpty;
    final count = activeRequests.length;

    final equipmentCount = equipment.length;
    final hasEquipment = equipmentCount > 0;

    final state = ref.watch(bookingProvider);

    // final newRequests = state.ownerBookings
    //     .where((b) => b.status == "CREATED")
    //     .toList();
    final upcomingJobs = state.ownerBookings
        .where((b) => b.status == "CONFIRMED")
        .toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 1. Header with Profile, Rating, and Chat
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 120,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(background: OwnerDashboardHeader()),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 12),
                //   child: Text(
                //     "Balance",
                //     style: const TextStyle(
                //       fontSize: 18,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.black87,
                //     ),
                //   ),
                // ),

                // Row(
                //   children: [
                //     _buildStatCard(
                //       context,
                //       "Online Time",
                //       "142 Min",
                //       const Color.fromARGB(255, 255, 0, 0),
                //       AppRoutes.ownerPayment,
                //     ),
                //   ],
                // ),
                BalanceTile(
                  minutes: 100,
                  burnRate: "min/hr",
                  progress: 0.15,
                  onTopUp: () {},
                ),

                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    "Performance",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),

                Row(
                  children: [
                    _buildStatCard(
                      context,
                      "Total Assets",
                      "24",
                      Colors.blue,
                      AppRoutes.ownerEquiment,
                    ),
                    const SizedBox(width: 12),
                    _buildStatCard(
                      context,
                      "Active Rents",
                      "08",
                      Colors.orange,
                      AppRoutes.ownerBookings,
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // 2. Client Requests Tile (High Priority)
                _buildActionTile(
                  context,
                  title: 'Client Requests',
                  subtitle: hasRequests
                      ? '$count new pending ${count == 1 ? 'request' : 'requests'}'
                      : 'No new requests at the moment',
                  icon: LucideIcons.users,
                  color: Colors.orange,
                  onTap: () => {
                    if (context.mounted)
                      {context.push(AppRoutes.ownerRequests)},
                  },
                ),
                const SizedBox(height: 16),

                // 3. Manage Equipment Tile
                _buildActionTile(
                  context,
                  title: 'Manage Equipment',
                  subtitle: hasEquipment
                      ? '$equipmentCount ${equipmentCount == 1 ? 'Item' : 'Items'} • Add or Edit'
                      : 'No items found • Tap to add',
                  icon: LucideIcons.hardHat,
                  color: colorScheme.primary,
                  onTap: () => {
                    if (context.mounted)
                      {context.push(AppRoutes.ownerEquiment)},
                  },
                ),

                const SizedBox(height: 16),

                RentAnEquipmentTile(),
              ]),
            ),
          ),

          // 4. Active Orders Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Active Orders',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // Circular shadow base
                      color: theme
                          .cardColor, // Solid base to block background colors
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: 0.2,
                          ), // Matches chat button depth
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: IconButton.filledTonal(
                      padding: const EdgeInsets.all(
                        10,
                      ), // Padding for the tap target
                      icon: const Icon(
                        LucideIcons
                            .history, // "Similar but different" to the chat icon
                        size: 20,
                      ),
                      onPressed: () {
                        if (context.mounted) {
                          context.push(AppRoutes.ownerBookingsHistory);
                        }
                      },
                      style: IconButton.styleFrom(
                        // Optional: use a different tonal color if you want to distinguish it
                        backgroundColor: theme.colorScheme.secondaryContainer
                            .withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// BOOKINGS SECTION
          if (state.isLoading)
            SliverToBoxAdapter(child: const OwnerBookingSkeleton())
          else if (upcomingJobs.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(
                  "No bookings yet",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final booking = upcomingJobs[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: OwnerBookingCard(booking: booking),
                  );
                }, childCount: upcomingJobs.length),
              ),
            ),

          SliverToBoxAdapter(
            child: ElevatedButton(
              onPressed: () => context.push(AppRoutes.ownerBookings),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("View All"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return BaseTile(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: theme.colorScheme.onPrimary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
        ],
      ),
    );
  }
}

Widget _buildStatCard(
  BuildContext context,
  String label,
  String value,
  Color color,
  String url,
) {
  return Expanded(
    child: GestureDetector(
      onTap: () => context.push(url),
      child: BaseTile(
        padding: const EdgeInsets.all(0),
        color: color.withValues(alpha: 0.15),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: color, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
