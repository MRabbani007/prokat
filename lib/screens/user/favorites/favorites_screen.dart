import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/core/widgets/page_header.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // In a real app, this list would come from a Database or SharedPreferences
  final List<String> _favoriteIds = ["cat-320-loader", "jlg-boom-lift"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _favoriteIds.isEmpty
          ? _buildEmptyState()
          : SafeArea(
              child: Column(
                children: [
                  PageHeader(title: "Favorites"),
                  ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _favoriteIds.length,
                    itemBuilder: (context, index) {
                      final id = _favoriteIds[index];
                      return Dismissible(
                        key: Key(id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          setState(() => _favoriteIds.removeAt(index));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("$id removed from favorites"),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: const Icon(
                              Icons.construction,
                              color: Colors.orange,
                            ),
                            title: Text(id.toUpperCase().replaceAll('-', ' ')),
                            subtitle: const Text("Atyrau Sector • \$450/day"),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                            ),
                            onTap: () => context.push('/equipment/$id'),
                          ),
                        ),
                      );
                    },
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
          Icon(Icons.favorite_border, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            "No favorites yet",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          TextButton(
            onPressed: () => context.go('/home'),
            child: const Text(
              "Explore Machinery",
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }
}
