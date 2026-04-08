import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:prokat/features/equipment/providers/equipment_provider.dart';

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
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 1. Header with Profile, Rating, and Chat
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeader(context),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // 2. Client Requests Tile (High Priority)
                _buildActionTile(
                  context,
                  title: 'Client Requests',
                  subtitle: '3 new pending requests',
                  icon: LucideIcons.users,
                  color: Colors.orange,
                  onTap: () => {}, // Navigate to Requests
                ),
                const SizedBox(height: 16),

                // 3. Manage Equipment Tile
                _buildActionTile(
                  context,
                  title: 'Manage Equipment',
                  subtitle: '12 Items • Add or Edit',
                  icon: LucideIcons.hardHat,
                  color: colorScheme.primary,
                  onTap: () => {}, // Navigate to Equipment List
                ),
                const SizedBox(height: 24),

                // 4. Active Orders Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Active Orders', 
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () {}, // Navigate to History
                      child: const Text('History'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Placeholder for Active Orders List
                _buildActiveOrderCard(context, "Excavator CAT 320", "Ends in 2 days"),
                _buildActiveOrderCard(context, "JCB Backhoe", "Ends in 5 days"),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Row(
        children: [
          // Profile Image
          CircleAvatar(
            radius: 35,
            backgroundColor: colorScheme.primaryContainer,
            child: const Icon(LucideIcons.user, size: 30),
          ),
          const SizedBox(width: 16),
          // Name and Rating
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('John\'s Rentals', 
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    const Icon(LucideIcons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text('4.9', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(' (128 reviews)', 
                      style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
          // Chat Button
          IconButton.filledTonal(
            icon: const Icon(LucideIcons.messageSquare),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(BuildContext context, {
    required String title, 
    required String subtitle, 
    required IconData icon, 
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                ],
              ),
            ),
            const Icon(LucideIcons.chevronRight, size: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveOrderCard(BuildContext context, String title, String time) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: ListTile(
        leading: const Icon(LucideIcons.truck),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(time),
        trailing: const Icon(LucideIcons.moreVertical, size: 18),
      ),
    );
  }
}

