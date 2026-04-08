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
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            // Header
            const UserDashboardHeader(),

            const SizedBox(height: 12),

            UserLocationTile(),

            const SizedBox(height: 12),

            // View active orders (created and confirmed), up to 2 orders, a history button and a view all button
            ClientBookingsSection(),

            const SizedBox(height: 12),

            // Button to create a custom request
            CreateRequestTile(),

            const SizedBox(height: 12),

            // Category selector
            const UserCategorySelector(),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "Browse Equipment",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            // Equipment list (NO local scroll)
            ...items.map(
              (equipment) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: EquipmentCard(
                  equipment: equipment,
                  onTap: () {
                    // Select equipment
                    bookingNotifier.selectEquipment(equipment);
                    // Navigate to booking screen
                    context.push('/equipment/${equipment.id}/book');
                  },
                  // isRenter: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
