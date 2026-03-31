import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/core/widgets/page_header.dart';
import 'package:prokat/features/auth/providers/auth_provider.dart';
import 'package:prokat/features/equipment/models/equipment_model.dart';
import 'package:prokat/features/equipment/providers/equipment_provider.dart';
import 'package:prokat/features/favorites/state/favorites_provider.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(favoriteProvider.notifier)
          .getFavorites(); // refetch ONCE when entering screen
    });
  }

  final bgColor = const Color(0xFF121417);
  final cardColor = const Color(0xFF1E2125);
  final accentColor = const Color(0xFF4E73DF);

  @override
  Widget build(BuildContext context) {
    final authSession = ref.watch(authProvider).session;

    final favoritesState = ref.watch(favoriteProvider);
    final equipmentState = ref.watch(equipmentProvider);

    final favoriteIds = favoritesState.favoritesIds;

    final favorites = equipmentState.renterEquipment
        .where((e) => favoriteIds?.contains(e.id) ?? false)
        .toList();

    final isLoading = equipmentState.isLoading || favoritesState.isLoading;
    final error = equipmentState.error ?? favoritesState.error;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageHeader(title: "Favorites"),

            authSession == null
                ? Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.login_outlined,
                            size: 64,
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Login to add and view favorites",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.70),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Expanded(
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : error != null
                        ? Center(child: Text("Error: $error"))
                        : equipmentState.renterEquipment.isEmpty
                        ? _buildEmptyState(context)
                        : _buildList(context, ref, favorites),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, WidgetRef ref, List equipments) {
    final notifier = ref.read(favoriteProvider.notifier);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: equipments.length,
      itemBuilder: (context, index) {
        final equipment = equipments[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Dismissible(
            key: Key(equipment.id),
            direction: DismissDirection.endToStart,
            onDismissed: (_) {
              notifier.toggleFavorite(equipment.id); // 🔥 remove favorite
            },
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 24),
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.delete_sweep_rounded,
                color: Colors.redAccent,
              ),
            ),
            child: _FavoriteCard(
              equipment: equipment,
              accentColor: accentColor,
              cardColor: cardColor,
              onTap: () => context.push('/equipment/${equipment.id}/book'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border_rounded,
            size: 80,
            color: Colors.white.withValues(alpha: 0.05),
          ),
          const SizedBox(height: 20),
          Text(
            "NO SAVED MACHINERY",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.2),
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: () => context.go('/search/map'),
            style: OutlinedButton.styleFrom(
              foregroundColor: accentColor,
              side: BorderSide(color: accentColor.withValues(alpha: 0.3)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              "EXPLORE FLEET",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final Equipment equipment;
  final Color accentColor;
  final Color cardColor;
  final VoidCallback onTap;

  const _FavoriteCard({
    required this.equipment,
    required this.accentColor,
    required this.cardColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final location = equipment.location != null
        ? "${equipment.location?.city}"
        : "Unknown location";

    final price = equipment.prices.isNotEmpty
        ? "${equipment.prices.first.price} ₸/${equipment.prices.first.priceRate}"
        : "No price";

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.precision_manufacturing_rounded,
                color: accentColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    equipment.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$location • $price",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.3),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white.withValues(alpha: 0.1),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
