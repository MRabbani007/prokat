import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/core/widgets/page_header.dart';
import 'package:prokat/features/bookings/state/booking_provider.dart';
import 'package:prokat/features/equipment/providers/equipment_provider.dart';
import 'package:prokat/features/equipment/widgets/list/equipment_city_selector.dart';
import 'package:prokat/features/equipment/widgets/list/equipment_list_tile.dart';
import 'package:prokat/features/equipment/widgets/list/equipment_map_button.dart';

class EquipmentListScreen extends ConsumerStatefulWidget {
  final String? q, category, city;
  const EquipmentListScreen({super.key, this.q, this.category, this.city});

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

    Future.microtask(() {
      ref.read(equipmentProvider.notifier).getRenterEquipment();
    });
  }

  @override
  Widget build(BuildContext context) {
    final equipmentState = ref.watch(equipmentProvider);
    final bookingNotifier = ref.read(bookingProvider.notifier);
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageHeader(title: "Search"),

            /// 1. INDUSTRIAL COMMAND HEADER
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: BoxDecoration(
                color: bgColor,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const EquipmentCitySelector(), // Assuming this matches the theme
                      const Spacer(),

                      // Industrial Search Toggle
                      _HeaderActionButton(
                        icon: _isSearchVisible
                            ? Icons.close_rounded
                            : Icons.search_rounded,
                        isActive: _isSearchVisible,
                        onTap: () => setState(
                          () => _isSearchVisible = !_isSearchVisible,
                        ),
                      ),

                      const SizedBox(width: 12),
                      const EquipmentMapButton(), // Ensure this is a Squircle too
                    ],
                  ),

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
                ],
              ),
            ),

            /// 2. LIST CONTENT
            Expanded(
              child: equipmentState.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF4E73DF),
                      ),
                    )
                  // : equipmentState.error != null
                  // ? Center(
                  //     child: Text(
                  //       equipmentState.error.toString(),
                  //       style: const TextStyle(color: Colors.redAccent),
                  //     ),
                  //   )
                  : equipmentState.renterEquipment.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: equipmentState.renterEquipment.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 16),
                      itemBuilder: (context, index) => EquipmentListTile(
                        equipment: equipmentState.renterEquipment[index],
                        onTap: () {
                          // Select equipment
                          bookingNotifier.selectEquipment(
                            equipmentState.renterEquipment[index],
                          );
                          // Navigate to booking screen
                          context.push(
                            '/equipment/${equipmentState.renterEquipment[index].id}/book',
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: Colors.white.withValues(alpha: 0.05),
          ),
          const SizedBox(height: 16),
          Text(
            "NO EQUIPMENT MATCHES",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.2),
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;

  const _HeaderActionButton({
    required this.icon,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF4E73DF)
              : Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Icon(
          icon,
          color: isActive ? Colors.white : const Color(0xFF4E73DF),
          size: 20,
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
