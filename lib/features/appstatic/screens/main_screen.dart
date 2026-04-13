import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ─── Data Models ────────────────────────────────────────────────────────────

class ServiceCategory {
  final String emoji;
  final String label;
  const ServiceCategory(this.emoji, this.label);
}

class RentalItem {
  final String emoji;
  final String name;
  final String category;
  final String city;
  final double rating;
  final int reviewCount;
  final int pricePerDay;
  final bool isTopRated;
  final Color thumbColor;
  const RentalItem({
    required this.emoji,
    required this.name,
    required this.category,
    required this.city,
    required this.rating,
    required this.reviewCount,
    required this.pricePerDay,
    required this.isTopRated,
    required this.thumbColor,
  });
}

// ─── Constants ───────────────────────────────────────────────────────────────

const Color kBlue = Color(0xFF2563EB);
const Color kBlueDark = Color(0xFF1E3A8A);
const Color kBgGray = Color(0xFFF8F9FB);
const Color kBorder = Color(0xFFE5E7EB);
const Color kTextPrimary = Color(0xFF111827);
const Color kTextSecondary = Color(0xFF6B7280);
const Color kTextMuted = Color(0xFF9CA3AF);

const List<String> kLanguages = ['RU', 'KZ', 'EN'];

const List<String> kCities = [
  'Almaty',
  'Astana',
  'Shymkent',
  'Karaganda',
  'Aktobe',
  'Taraz',
  'Pavlodar',
  'Atyrau',
  'Oskemen',
];

const List<ServiceCategory> kCategories = [
  ServiceCategory('🏗️', 'Construction'),
  ServiceCategory('🚗', 'Vehicles'),
  ServiceCategory('🎉', 'Events'),
  ServiceCategory('⚡', 'Electric'),
  ServiceCategory('🌿', 'Garden'),
  ServiceCategory('📷', 'Photo & Video'),
  ServiceCategory('🛻', 'Cargo'),
  ServiceCategory('🔧', 'Tools'),
];

const List<String> kFilters = [
  'All',
  'Daily',
  'Weekly',
  'Monthly',
  'Near me',
  'New',
];

const List<RentalItem> kRentals = [
  RentalItem(
    emoji: '🏗️',
    name: 'Hilti TE 70 Rotary Hammer',
    category: 'Construction tools',
    city: 'Almaty',
    rating: 4.9,
    reviewCount: 128,
    pricePerDay: 3500,
    isTopRated: false,
    thumbColor: Color(0xFFEFF6FF),
  ),
  RentalItem(
    emoji: '🚐',
    name: 'Mercedes Sprinter Van',
    category: 'Cargo vehicles',
    city: 'Almaty',
    rating: 4.8,
    reviewCount: 94,
    pricePerDay: 18000,
    isTopRated: true,
    thumbColor: Color(0xFFFFFBEB),
  ),
  RentalItem(
    emoji: '🎪',
    name: 'Event Tent 6×12 m',
    category: 'Events & parties',
    city: 'Almaty',
    rating: 4.7,
    reviewCount: 61,
    pricePerDay: 22000,
    isTopRated: false,
    thumbColor: Color(0xFFF0FDF4),
  ),
  RentalItem(
    emoji: '📷',
    name: 'Sony FX6 Cinema Camera',
    category: 'Photo & video',
    city: 'Almaty',
    rating: 5.0,
    reviewCount: 43,
    pricePerDay: 12500,
    isTopRated: true,
    thumbColor: Color(0xFFF5F3FF),
  ),
];

// ─── Home Screen ─────────────────────────────────────────────────────────────

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _selectedLang = 'EN';
  String _selectedCity = 'Almaty';
  String _selectedFilter = 'All';
  int _navIndex = 0;

  void _showCityPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => CityPickerSheet(
        selected: _selectedCity,
        onSelect: (city) {
          setState(() => _selectedCity = city);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgGray,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(
              selectedLang: _selectedLang,
              onLangChanged: (l) => setState(() => _selectedLang = l),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeroBanner(
                      city: _selectedCity,
                      onCityTap: _showCityPicker,
                    ),
                    const SizedBox(height: 20),
                    _SectionHeader(title: 'Services', onSeeAll: () {}),
                    const SizedBox(height: 14),
                    const _CategoryGrid(),
                    const SizedBox(height: 20),
                    _FilterPills(
                      selected: _selectedFilter,
                      onSelect: (f) => setState(() => _selectedFilter = f),
                    ),
                    const SizedBox(height: 20),
                    _SectionHeader(
                      title: 'Top ranked rentals',
                      onSeeAll: () {},
                    ),
                    const SizedBox(height: 14),
                    const _RentalList(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNav(
        index: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }
}

// ─── Top Bar ─────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final String selectedLang;
  final ValueChanged<String> onLangChanged;

  const _TopBar({required this.selectedLang, required this.onLangChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: ()=>context.push("/login"),
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.04 * 22,
                      color: Color(0xFF1A1A2E),
                    ),
                    children: [
                      TextSpan(text: 'PRO'),
                      TextSpan(
                        text: 'KAT',
                        style: TextStyle(color: kBlue),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: kLanguages.map((lang) {
                  final active = lang == selectedLang;
                  return GestureDetector(
                    onTap: () => onLangChanged(lang),
                    child: Container(
                      margin: const EdgeInsets.only(left: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: active ? kBlue : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: active ? kBlue : const Color(0xFFD1D5DB),
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        lang,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: active ? Colors.white : kTextSecondary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, size: 16, color: kTextMuted),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Search equipment...',
                    style: const TextStyle(fontSize: 14, color: kTextMuted),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Hero Banner ─────────────────────────────────────────────────────────────

class _HeroBanner extends StatelessWidget {
  final String city;
  final VoidCallback onCityTap;

  const _HeroBanner({required this.city, required this.onCityTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "KAZAKHSTAN'S #1 RENTAL PLATFORM",
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.7),
              letterSpacing: 0.08 * 11,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Find & rent equipment\nin minutes',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: onCityTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white.withOpacity(0.25),
                  width: 0.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: Colors.white.withOpacity(0.85),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    city,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const _SectionHeader({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: kTextPrimary,
            ),
          ),
          GestureDetector(
            onTap: onSeeAll,
            child: const Text(
              'See all',
              style: TextStyle(fontSize: 12, color: kBlue),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Category Grid ────────────────────────────────────────────────────────────

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.9,
        ),
        itemCount: kCategories.length,
        itemBuilder: (_, i) => _CategoryCard(cat: kCategories[i]),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final ServiceCategory cat;
  const _CategoryCard({required this.cat});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBorder, width: 0.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(cat.emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 6),
          Text(
            cat.label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─── Filter Pills ─────────────────────────────────────────────────────────────

class _FilterPills extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelect;

  const _FilterPills({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: kFilters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final active = kFilters[i] == selected;
          return GestureDetector(
            onTap: () => onSelect(kFilters[i]),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: active ? const Color(0xFFEFF6FF) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: active
                      ? const Color(0xFFBFDBFE)
                      : const Color(0xFFD1D5DB),
                  width: 0.5,
                ),
              ),
              child: Text(
                kFilters[i],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: active ? kBlue : const Color(0xFF374151),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Rental List ──────────────────────────────────────────────────────────────

class _RentalList extends StatelessWidget {
  const _RentalList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: kRentals
            .map(
              (r) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _RentalCard(item: r),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _RentalCard extends StatelessWidget {
  final RentalItem item;
  const _RentalCard({required this.item});

  String _stars(double rating) {
    final full = rating.floor();
    final half = (rating - full) >= 0.5 ? 1 : 0;
    final empty = 5 - full - half;
    return ('★' * full) + (half == 1 ? '½' : '') + ('☆' * empty);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kBorder, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: item.thumbColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(item.emoji, style: const TextStyle(fontSize: 32)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: kTextPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${item.category} · ${item.city}',
                  style: const TextStyle(fontSize: 12, color: kTextSecondary),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      _stars(item.rating),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFFF59E0B),
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${item.rating} (${item.reviewCount})',
                      style: const TextStyle(fontSize: 11, color: kTextMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                '${item.pricePerDay.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]} ')} ₸',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1D4ED8),
                            ),
                          ),
                          const TextSpan(
                            text: ' / day',
                            style: TextStyle(fontSize: 11, color: kTextMuted),
                          ),
                        ],
                      ),
                    ),
                    _Badge(isTopRated: item.isTopRated),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final bool isTopRated;
  const _Badge({required this.isTopRated});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isTopRated ? const Color(0xFFFFF7ED) : const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isTopRated ? const Color(0xFFFED7AA) : const Color(0xFFBBF7D0),
          width: 0.5,
        ),
      ),
      child: Text(
        isTopRated ? 'Top rated' : 'Available',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: isTopRated ? const Color(0xFF9A3412) : const Color(0xFF166534),
        ),
      ),
    );
  }
}

// ─── City Picker Bottom Sheet ─────────────────────────────────────────────────

class CityPickerSheet extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelect;

  const CityPickerSheet({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: kBorder,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Select City',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: kTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        ...kCities.map(
          (city) => ListTile(
            title: Text(
              city,
              style: TextStyle(
                fontSize: 14,
                color: city == selected ? kBlue : kTextPrimary,
                fontWeight: city == selected
                    ? FontWeight.w500
                    : FontWeight.normal,
              ),
            ),
            trailing: city == selected
                ? const Icon(Icons.check, color: kBlue, size: 18)
                : null,
            onTap: () => onSelect(city),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

// ─── Bottom Navigation Bar ────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const items = [
      {'icon': Icons.home_outlined, 'activeIcon': Icons.home, 'label': 'Home'},
      {'icon': Icons.search, 'activeIcon': Icons.search, 'label': 'Explore'},
      {
        'icon': Icons.list_alt_outlined,
        'activeIcon': Icons.list_alt,
        'label': 'My rentals',
      },
      {
        'icon': Icons.chat_bubble_outline,
        'activeIcon': Icons.chat_bubble,
        'label': 'Messages',
      },
      {
        'icon': Icons.person_outline,
        'activeIcon': Icons.person,
        'label': 'Profile',
      },
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: kBorder, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (i) {
            final active = i == index;
            final item = items[i];
            return GestureDetector(
              onTap: () => onTap(i),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      active
                          ? item['activeIcon'] as IconData
                          : item['icon'] as IconData,
                      size: 22,
                      color: active ? kBlue : kTextMuted,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item['label'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        color: active ? kBlue : kTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
