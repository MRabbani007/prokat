import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/bookings/state/booking_provider.dart';
import 'package:prokat/features/bookings/widgets/client_bookings_section.dart';
import 'package:prokat/features/categories/models/category.dart';
import 'package:prokat/features/categories/providers/category_provider.dart';
import 'package:prokat/features/equipment/providers/equipment_provider.dart';
import 'package:prokat/features/user/widgets/equipment_card.dart';
import 'package:prokat/features/user/widgets/selected_categorty_tile.dart';
import 'package:prokat/features/user/widgets/user_category_selector.dart';
import 'package:prokat/features/user/widgets/user_dashboard_header.dart';
import 'package:prokat/features/user/widgets/user_equipment_tile.dart';
import 'package:prokat/features/user/widgets/user_location_tile.dart';
import 'package:go_router/go_router.dart';

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
    final categoriesState = ref.watch(categoriesProvider);
    final items = ref.watch(equipmentProvider).renterEquipment;
    final bookingNotifier = ref.read(bookingProvider.notifier);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 16),
          children: [
            // Header
            const UserDashboardHeader(),

            const SizedBox(height: 12),

            // Location + category row
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 12),
            //   child: Row(
            //     children: [
            //       Expanded(child: UserLocationTile()),

            //       const SizedBox(width: 12),

            //       Expanded(
            //         child: categoriesState.selectedCategory != null
            //             ? SelectedCategoryTile(
            //                 category:
            //                     categoriesState.selectedCategory as Category,
            //                 clearSelected: () => ref
            //                     .read(categoriesProvider.notifier)
            //                     .clearCategory(),
            //               )
            //             : const SizedBox(),
            //       ),
            //     ],
            //   ),
            // ),

            // Category selector
            const UserCategorySelector(),

            const SizedBox(height: 12),

            ClientBookingsSection(),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "Equipment",
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
