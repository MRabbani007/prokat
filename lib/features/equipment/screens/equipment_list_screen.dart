import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/core/router/app_routes.dart';
import 'package:prokat/features/bookings/state/booking_provider.dart';
import 'package:prokat/features/equipment/providers/equipment_provider.dart';
import 'package:prokat/features/favorites/state/favorites_provider.dart';
import 'package:prokat/features/favorites/widgets/favorites_section.dart';
import 'package:prokat/features/locations/state/location_provider.dart';
import 'package:prokat/features/user/widgets/user_category_selector.dart';
import 'package:prokat/features/equipment/widgets/list/client_equipment_card.dart';
import 'package:prokat/features/user/widgets/user_location_tile.dart';

class EquipmentListScreen extends ConsumerStatefulWidget {
  final String? query, category, city;
  final int? page, limit;

  const EquipmentListScreen({
    super.key,
    this.query,
    this.category,
    this.city,
    this.page,
    this.limit,
  });

  @override
  ConsumerState<EquipmentListScreen> createState() =>
      _EquipmentListScreenState();
}

class _EquipmentListScreenState extends ConsumerState<EquipmentListScreen> {
  bool _isSearchVisible = false;
  final bgColor = const Color(0xFF121417);
  final cardColor = const Color(0xFF1E2125);
  final accentColor = const Color(0xFF4E73DF);

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final city = ref.watch(locationProvider).city;

      ref
          .read(equipmentProvider.notifier)
          .getRenterEquipment(
            categoryId: widget.category,
            query: widget.query,
            page: widget.page,
            limit: widget.limit,
            city: city,
          );

      ref.read(favoriteProvider.notifier).getFavorites();
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
              expandedHeight: 60, // Adjust height as needed
              floating: true, // AppBar reappears immediately when scrolling up
              pinned: false, // AppBar hides completely when scrolling down
              backgroundColor: theme.colorScheme.primary,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 20,
                  color: theme.colorScheme.onPrimary,
                ),
                onPressed: () => context.pop(),
              ),
              title: Text(
                "Browse Equipment",
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              centerTitle: false,
              actions: [
                IconButton(
                  onPressed: () =>
                      setState(() => _isSearchVisible = !_isSearchVisible),
                  icon: Icon(
                    Icons.search_rounded,
                    color: theme.colorScheme.onPrimary,
                    size: 24,
                  ),
                  tooltip: "Search",
                ),
                IconButton(
                  onPressed: () => context.push(AppRoutes.searchMap),
                  icon: Icon(
                    Icons.map,
                    color: theme.colorScheme.onPrimary,
                    size: 24,
                  ),
                  tooltip: "View on Map",
                ),
              ],
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserLocationTile(),

                    const SizedBox(height: 24),

                    /// Animated Search Bar
                    AnimatedVisibility(
                      visible: _isSearchVisible,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "SEARCH FLEET...",
                            hintStyle: TextStyle(
                              color: Colors.white.withValues(alpha: 0.2),
                              fontSize: 12,
                              letterSpacing: 1,
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: accentColor,
                              size: 20,
                            ),
                            filled: true,
                            fillColor: Colors.white.withValues(alpha: 0.03),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: Colors.white.withValues(alpha: 0.08),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: Color(0xFF4E73DF),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    FavoritesSection(),

                    const SizedBox(height: 12),

                    const UserCategorySelector(),

                    const SizedBox(height: 12),

                    Text(
                      "Browse Equipment",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. The dynamic list using SliverList
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final equipment = items[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  child: ClientEquipmentCard(
                    equipment: equipment,
                    onTap: () {
                      bookingNotifier.selectEquipment(equipment);
                      context.push('/equipment/${equipment.id}/book');
                    },
                  ),
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

class AnimatedVisibility extends StatelessWidget {
  final bool visible;
  final Widget child;

  const AnimatedVisibility({
    super.key,
    required this.visible,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: child,
      secondChild: const SizedBox(width: double.infinity),
      crossFadeState: visible
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 250),
    );
  }
}
