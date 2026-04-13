import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/features/equipment/providers/equipment_provider.dart';
import 'package:prokat/features/equipment/widgets/owner/owner_equipment_card.dart';
import 'package:shimmer/shimmer.dart';

class OwnerEquipmentListScreen extends ConsumerStatefulWidget {
  const OwnerEquipmentListScreen({super.key});

  @override
  ConsumerState<OwnerEquipmentListScreen> createState() =>
      _OwnerEquipmentListScreenState();
}

class _OwnerEquipmentListScreenState
    extends ConsumerState<OwnerEquipmentListScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(
      () => ref.read(equipmentProvider.notifier).getOwnerEquipment(),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(equipmentProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // 1. App Bar with Back Button
          SliverAppBar(
            floating: true,
            pinned: true,
            elevation: 0,
            scrolledUnderElevation: 2, 
            backgroundColor: theme.colorScheme.surface,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: () => context.pop(),
            ),
            title: Text(
              "My Equipment",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: IconButton.filled(
                  // filled variant uses primary by default
                  onPressed: () => context.push('/owner/equipment/create'),
                  icon: const Icon(Icons.add, size: 24),
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    shape: CircleBorder(),
                  ),
                ),
              ),
            ],
          ),

          // 2. Stats and Add Button Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatusItem(
                      context,
                      label: "ONLINE",
                      count: state.ownerEquipment
                          .where((e) => e.status.toLowerCase() == 'available')
                          .length,
                      color: Colors.greenAccent[700]!,
                    ),
                  ),
                  SizedBox(width: 12),

                  Expanded(
                    child: _buildStatusItem(
                      context,
                      label: "OFFLINE",
                      count: state.ownerEquipment
                          .where((e) => e.status.toLowerCase() == 'booked')
                          .length,
                      color: Colors.redAccent[400]!,
                    ),
                  ),
                  SizedBox(width: 12),

                  Expanded(
                    child: _buildStatusItem(
                      context,
                      label: "REPAIR",
                      count: state.ownerEquipment
                          .where((e) => e.status.toLowerCase() == 'maintenance')
                          .length,
                      color: Colors.orangeAccent[700]!,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Dynamic List Content
          if (state.isLoading)
            _buildSliverSkeleton(context)
          else if (state.ownerEquipment.isEmpty)
            _buildSliverEmptyState(context)
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: OwnerEquipmentCard(
                      equipment: state.ownerEquipment[index],
                    ),
                  ),
                  childCount: state.ownerEquipment.length,
                ),
              ),
            ),

          // Bottom spacing for scroll comfort
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildSliverSkeleton(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Shimmer.fromColors(
            baseColor: Colors.grey.shade200,
            highlightColor: Colors.grey.shade50,
            child: Container(
              height: 140,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          childCount: 4,
        ),
      ),
    );
  }

  Widget _buildSliverEmptyState(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          const Text(
            "No equipment listed yet",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(
    BuildContext context, {
    required String label,
    required int count,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // The Large Count
          Text(
            count.toString(),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          // The Label
          Text(
            label.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
