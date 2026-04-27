import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/equipment/models/equipment_model.dart';
import 'package:prokat/features/equipment/widgets/list/equipment_list_tile.dart';
import 'package:prokat/features/favorites/state/favorites_provider.dart';

class SwipeableListTile extends ConsumerWidget {
  final Equipment equipment;
  final VoidCallback onTap;
  final bool isRenter;

  const SwipeableListTile({
    super.key,
    required this.equipment,
    required this.onTap,
    required this.isRenter,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(favoriteProvider);
    final bool isFavorite = ref
        .read(favoriteProvider.notifier)
        .isFavorite(equipment.id);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Dismissible(
        key: ValueKey('fav_${equipment.id}'),
        direction: DismissDirection.startToEnd, // Swipe right only
        dismissThresholds: const {DismissDirection.startToEnd: 0.4},
        confirmDismiss: (direction) async {
          // Toggle favorite on swipe without removing the tile from the list
          isRenter
              ? ref.read(favoriteProvider.notifier).toggleFavorite(equipment.id)
              : null;
          return false; // Return false so the tile snaps back instead of disappearing
        },
        background: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 30),
          decoration: BoxDecoration(
            color: isFavorite
                ? Colors.grey.withValues(alpha: 0.3)
                : Colors.redAccent.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            isFavorite ? Icons.favorite_border : Icons.favorite,
            color: Colors.white,
            size: 32,
          ),
        ),
        child: EquipmentListTile(
          equipment: equipment,
          onTap: onTap,
          isRenter: isRenter,
        ),
      ),
    );
  }
}
