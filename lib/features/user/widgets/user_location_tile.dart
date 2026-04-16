import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/core/widgets/base_tile.dart';
import 'package:prokat/features/locations/state/location_provider.dart';
import 'package:prokat/features/user/state/user_profile_provider.dart';

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

class UserLocationTile extends ConsumerWidget {
  const UserLocationTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationState = ref.watch(locationProvider);

    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;

    final selectedCity = locationState.city;

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => _CityPickerSheet(),
        );
      },
      child: BaseTile(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        // decoration: BoxDecoration(
        //   color: theme.cardColor,
        //   border: Border.all(
        //     color: theme.colorScheme.outline.withValues(alpha: 0.3),
        //   ),
        //   borderRadius: BorderRadius.circular(12),
        //   boxShadow: [
        //     BoxShadow(
        //       color: Colors.black.withValues(alpha: 0.3),
        //       blurRadius: 6,
        //       offset: const Offset(0, 4),
        //     ),
        //   ],
        // ),
        child: Row(
          children: [
            Icon(Icons.location_on, color: accent, size: 28),

            const SizedBox(width: 8),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedCity != null && selectedCity != ""
                        ? "City"
                        : "Location",
                    style: theme.textTheme.labelMedium,
                  ),

                  const SizedBox(width: 4),

                  Text(
                    selectedCity != null && selectedCity != ""
                        ? selectedCity
                        : "Select City",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: selectedCity == null ? Colors.grey[600] : accent,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 4),

            Icon(Icons.keyboard_arrow_down, size: 20, color: accent),
          ],
        ),
      ),
    );
  }
}

class _CityPickerSheet extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    leading: const Icon(Icons.location_city),
                    title: Text(city),
                    onTap: () {
                      ref.read(locationProvider.notifier).selectCity(city);

                      ref
                          .read(userProfileProvider.notifier)
                          .selectselectCityRegion(city, "No Region");

                      Navigator.pop(context);
                    },
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
