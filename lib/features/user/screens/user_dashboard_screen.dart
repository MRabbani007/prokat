import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/bookings/state/booking_provider.dart';
import 'package:prokat/features/bookings/widgets/client_bookings_section.dart';
import 'package:prokat/features/equipment/providers/equipment_provider.dart';
import 'package:prokat/features/requests/widgets.dart/create_request_tile.dart';
import 'package:prokat/features/user/widgets/equipment_card.dart';
import 'package:prokat/features/user/widgets/user_category_selector.dart';
import 'package:prokat/features/user/widgets/user_dashboard_header.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/features/user/widgets/user_location_tile.dart';

class UserDashboardPage extends ConsumerStatefulWidget {
  const UserDashboardPage({super.key});

  @override
  ConsumerState<UserDashboardPage> createState() => _UserDashboardPageState();
}

class _UserDashboardPageState extends ConsumerState<UserDashboardPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(equipmentProvider.notifier).getRenterEquipment();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = ref.watch(equipmentProvider).renterEquipment;
    final bookingNotifier = ref.read(bookingProvider.notifier);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 160.0, // Adjust height as needed
              floating: true, // AppBar reappears immediately when scrolling up
              pinned: false, // AppBar hides completely when scrolling down
              backgroundColor: theme.colorScheme.primary,
              flexibleSpace: FlexibleSpaceBar(
                background: UserDashboardHeader(), // Your header widget
              ),
            ),

            // 1. Static components wrapped in SliverToBoxAdapter
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 18),
                  UserLocationTile(),
                  const SizedBox(height: 12),
                  ClientBookingsSection(),
                  const SizedBox(height: 12),
                  CreateRequestTile(),
                  const SizedBox(height: 12),
                  const UserCategorySelector(),
                  const SizedBox(height: 12),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "Browse Equipment",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),

            // 2. The dynamic list using SliverList
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final equipment = items[index];
                return EquipmentCard(
                  equipment: equipment,
                  onTap: () {
                    bookingNotifier.selectEquipment(equipment);
                    context.push('/equipment/${equipment.id}/book');
                  },
                );
              }, childCount: items.length),
            ),

            // 3. Bottom padding
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}
