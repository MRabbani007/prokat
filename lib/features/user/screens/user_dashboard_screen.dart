import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/categories/models/category.dart';
import 'package:prokat/features/categories/providers/category_provider.dart';
import 'package:prokat/features/equipment/providers/equipment_provider.dart';
import 'package:prokat/features/user/widgets/selected_categorty_tile.dart';
import 'package:prokat/features/user/widgets/user_category_selector.dart';
import 'package:prokat/features/user/widgets/user_dashboard_header.dart';
import 'package:prokat/features/user/widgets/user_equipment_tile.dart';
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
    final categoriesState = ref.watch(categoriesProvider);
    // final bg = theme.scaffoldBackgroundColor;
    // final card = theme.cardColor;
    // final accent = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      // Use a CustomScrollView for a smoother feel with a pinned header if needed
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserDashboardHeader(),

            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: UserLocationTile(),
                  ),
                ),

                if (categoriesState.showSelect == false &&
                    categoriesState.selectedCategory != null) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: categoriesState.showSelect == false
                        ? SelectedServiceTile(
                            service:
                                categoriesState.selectedCategory as Category,
                            clearSelected: () => ref
                                .watch(categoriesProvider.notifier)
                                .clearCategory(),
                          )
                        : SizedBox(),
                  ),
                ],
              ],
            ),

            SizedBox(height: 8),

            UserCategorySelector(),

            // const Padding(
            //   padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
            //   child: Text(
            //     "Nearby Equipment",
            //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            //   ),
            // ),
            Expanded(child: _buildEquipmentList(context, ref)),
          ],
        ),
      ),
    );
  }

  Widget _buildEquipmentList(BuildContext context, WidgetRef ref) {
    final items = ref.watch(equipmentProvider).renterEquipment;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final equipment = items[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: UserEquipmentTile(
            equipment: equipment,
            onTap: () {},
            isRenter: true,
          ),
        );
      },
    );
  }
}
