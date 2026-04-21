import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/core/router/app_routes.dart';
import 'package:prokat/features/appstatic/widgets/category_card.dart';
import 'package:prokat/features/appstatic/widgets/search_box.dart';
import 'package:prokat/features/categories/providers/category_provider.dart';
import 'package:prokat/features/equipment/providers/equipment_provider.dart';
import 'package:prokat/features/equipment/widgets/list/guest_equipment_card.dart';

const Color kBlue = Color(0xFF2563EB);
const Color kBlueDark = Color(0xFF1E3A8A);
const Color kBgGray = Color(0xFFF8F9FB);
const Color kBorder = Color(0xFFE5E7EB);
const Color kTextPrimary = Color(0xFF111827);
const Color kTextSecondary = Color(0xFF6B7280);
const Color kTextMuted = Color(0xFF9CA3AF);

const List<String> kLanguages = ['RU', 'KZ', 'EN'];

const kazakhstanCities = [
  'Almaty',
  'Astana',
  'Shymkent',
  'Atyrau',
  'Aktobe',
  'Karaganda',
  'Taraz',
  'Pavlodar',
  'Ust-Kamenogorsk',
  'Semey',
  'Kostanay',
  'Kyzylorda',
  'Uralsk',
  'Petropavl',
  'Turkistan',
];

class MainScreen extends ConsumerStatefulWidget {
  final String? query, category, city;
  final int? page, limit;

  const MainScreen({
    super.key,
    this.query,
    this.category,
    this.city,

    this.page,
    this.limit,
  });

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  String _selectedFilter = 'All';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(equipmentProvider.notifier)
          .getRenterEquipment(
            categoryId: widget.category,
            query: widget.query,
            page: widget.page,
            limit: widget.limit,
            city: widget.city,
          );

      ref.read(categoriesProvider.notifier).getCategories();
    });
  }

  void _updateFilters(BuildContext context, Map<String, String?> newParams) {
    final uri = GoRouterState.of(context).uri;
    final currentParams = Map<String, String>.from(uri.queryParameters);

    // Add/Update new parameters, remove if value is null
    newParams.forEach((key, value) {
      if (value == null) {
        currentParams.remove(key);
      } else {
        currentParams[key] = value;
      }
    });

    currentParams['page'] = '1';

    context.go(
      Uri(path: AppRoutes.main, queryParameters: currentParams).toString(),
    );
  }

  @override
  void didUpdateWidget(covariant MainScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    final paramsChanged =
        oldWidget.query != widget.query ||
        oldWidget.city != widget.city ||
        oldWidget.category != widget.category ||
        oldWidget.page != widget.page;

    if (paramsChanged) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();

      _debounce = Timer(const Duration(seconds: 2), () {
        ref
            .read(equipmentProvider.notifier)
            .getRenterEquipment(
              city: widget.city ?? "",
              categoryId: widget.category ?? "",
              query: widget.query ?? "",
              page: widget.page ?? 1,
            );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final categoriesState = ref.watch(categoriesProvider);
    final equipmentState = ref.watch(equipmentProvider);

    final selectedCity = widget.city ?? "";
    final selectedCategory = widget.category ?? "";

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              // 'pinned' keeps the small toolbar visible; 'false' hides it completely
              pinned: true,
              // 'floating' makes it reappear as soon as you scroll up
              floating: true,
              // 'snap' makes it animate fully into/out of view
              snap: true,
              expandedHeight: 120.0, // Height when fully expanded
              backgroundColor: theme.colorScheme.surface,
              titleSpacing: 0,
              title: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // LOGO
                    GestureDetector(
                      onTap: () {},
                      child: RichText(
                        softWrap: false,
                        text: TextSpan(
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                          children: [
                            const TextSpan(text: 'PRO'),
                            TextSpan(
                              text: 'KAT',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // LANGUAGE BUTTON
                    GestureDetector(
                      onTap: () => _showLanguagePicker(
                        context,
                      ), // Trigger your dropdown here
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "EN",
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actionsPadding: EdgeInsets.only(right: 12),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(80),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SearchBox(), // The search box from earlier
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: _HeroBanner(
                city: selectedCity,
                onCityTap: () => {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (_) => _CityPickerSheet(
                      selected: selectedCity,
                      onSelect: (city) {
                        // setState(() => _selectedCity = city);
                        _updateFilters(context, {'city': city});

                        Navigator.pop(context);
                      },
                    ),
                  ),
                },
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: GestureDetector(
                  onTap: () {
                    context.push(AppRoutes.login);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Get Started',
                          style: TextStyle(
                            color: theme.colorScheme.onPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.login,
                          size: 24,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: _SectionHeader(title: 'Services', onSeeAll: () {}),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.only(top: 14),
              sliver: SliverToBoxAdapter(child: Container()),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ), // Adjust padding as needed
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.9,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, i) => CategoryCard(
                    isSelected:
                        selectedCategory == categoriesState.categories[i].id,
                    category: categoriesState.categories[i],
                    onTap: () => _updateFilters(context, {
                      'category': categoriesState.categories[i].id,
                    }),
                  ),
                  childCount: categoriesState.categories.length,
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    _SectionHeader(title: 'Popular rents', onSeeAll: () {}),

                    const SizedBox(height: 14),

                    // Text("Search: $currentQuery"),
                    _FilterPills(
                      selected: _selectedFilter,
                      onSelect: (f) => setState(() => _selectedFilter = f),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final item = equipmentState.renterEquipment[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GuestEquipmentCard(item: item),
                  );
                }, childCount: equipmentState.renterEquipment.length),
              ),
            ),
          ],
        ),
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
              color: Colors.white.withValues(alpha: 0.7),
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
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.25),
                  width: 0.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    city.isNotEmpty ? city : "All Locations",
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
                    color: Colors.white.withValues(alpha: 0.7),
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

// ─── Filter Pills ─────────────────────────────────────────────────────────────
const List<String> kFilters = ['All', 'Daily', 'Weekly', 'Monthly', 'Near me'];

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
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final active = kFilters[i] == selected;
          return GestureDetector(
            onTap: () => onSelect(kFilters[i]),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
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

// ─── City Picker Bottom Sheet ─────────────────────────────────────────────────

class _CityPickerSheet extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelect;

  const _CityPickerSheet({
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text('Select City', style: theme.textTheme.titleLarge),

            const SizedBox(height: 12),

            // City list
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: kazakhstanCities.length,
                separatorBuilder: (_, _) => const Divider(),
                itemBuilder: (context, index) {
                  final city = kazakhstanCities[index];

                  return ListTile(
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showLanguagePicker(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      final theme = Theme.of(context);

      return Padding(
        padding: const EdgeInsets.only(bottom: 24, top: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Sheet takes only needed height
          children: [
            // Handle for visual cue
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Select Language",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _LanguageTile(title: "Қазақша", code: "KZ", isSelected: false),
            _LanguageTile(title: "Русский", code: "RU", isSelected: false),
            _LanguageTile(title: "English", code: "EN", isSelected: true),
          ],
        ),
      );
    },
  );
}

class _LanguageTile extends StatelessWidget {
  final String title;
  final String code;
  final bool isSelected;

  const _LanguageTile({
    required this.title,
    required this.code,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: CircleAvatar(
        radius: 14,
        backgroundColor: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.surfaceVariant,
        child: Text(
          code,
          style: TextStyle(
            fontSize: 10,
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
          : null,
      onTap: () {
        // 1. Update your locale state here (e.g., ref.read(localeProvider.notifier).update(...))
        // 2. Close the sheet
        Navigator.pop(context);
      },
    );
  }
}
