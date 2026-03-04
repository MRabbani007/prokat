import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/models/equipment.dart';
import 'package:prokat/screens/user/search/equipment_card.dart';

class SearchListScreen extends StatefulWidget {
  final String? q;
  final String? category;
  final String? city;

  const SearchListScreen({super.key, this.q, this.category, this.city});

  @override
  State<SearchListScreen> createState() => _SearchListScreenState();
}

class _SearchListScreenState extends State<SearchListScreen> {
  final ScrollController _scrollController = ScrollController();

  final List _items = [];
  bool _isLoading = false;
  int _currentPage = 1;

  final String _currentCity = "Atyrau";

  @override
  void initState() {
    super.initState();
    _fetchPage(); // Initial load
    _scrollController.addListener(_onScroll);
  }

  // Simulated API Call
  Future<void> _fetchPage() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    List newItems = List.generate(10, (i) {
      int itemNum = ((_currentPage - 1) * 10) + i + 1;
      return EquipmentModel(
        id: "$itemNum",
        name: "Heavy Duty Excavator",
        model: "CAT 320EL $itemNum",
        price: 350, //"\$${(350 + i * 5)}/day",
        location: widget.city ?? 'Site A, Kulsary', // Uses the passed city
        owner: "Smith & Co.",
        capacity: 20, //"20 Ton Capacity",
        imageUrl: "assets/images/categories/septic_truck.jpg",
        available: true,
        latitude: 0,
        longitude: 0,
      );
    });

    setState(() {
      _items.addAll(newItems);
      _isLoading = false;
      _currentPage++;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _fetchPage();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Dynamic Filter Section ---
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                // 1. City Button (e.g., Atyrau)
                ActionChip(
                  avatar: const Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.orange,
                  ),
                  label: Text(_currentCity),
                  onPressed: () {}, // Function to update to 'Atyrau'
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                //  Map Shortcut Button
                IconButton(
                  icon: const Icon(Icons.map_outlined, color: Colors.blue),
                  tooltip: "View on Map",
                  onPressed: () => context.push('/search/map'),
                ),

                // 2. Category Filter (e.g., Forklifts)
                if (widget.category != null && widget.category!.isNotEmpty)
                  InputChip(
                    label: Text(widget.category!),
                    selected: true,
                    selectedColor: Colors.orange.withOpacity(0.2),
                    // onDeleted: () =>
                    //     context.go('/home/search'), // Clear filters
                  ),

                // 3. Search Query (e.g., "q")
                if (widget.q != null && widget.q!.isNotEmpty)
                  Chip(
                    label: Text('Search: ${widget.q}'),
                    backgroundColor: Colors.blue.shade50,
                  ),
              ],
            ),
          ),

          // --- The Main Infinite Scroll List ---
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              // Add padding to bottom so the last card isn't cut off
              padding: const EdgeInsets.only(bottom: 24),
              itemCount: _items.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < _items.length) {
                  // Using your requested visual card
                  return EquipmentCard(
                    item: _items[index],
                    onTap: () {
                      context.push(
                        '/equipment/${_items[index].model.replaceAll(' ', '-').toLowerCase()}',
                      );
                    },
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.orange,
                        strokeWidth: 3,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
