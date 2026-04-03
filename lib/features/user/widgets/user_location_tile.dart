import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/locations/state/location_provider.dart';

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

    // Determine display text
    final location = locationState.selectedAddress;
    final selectedCity = locationState.city;

    String displayText = 'Select location';

    if (location != null) {
      if (location.city.isNotEmpty) {
        displayText = location.city;
      } else if (location.street.isNotEmpty) {
        displayText = location.street;
      }
    } else if (selectedCity != null) {
      displayText = selectedCity;
    }

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) {
            return _CityPickerSheet();
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: accent.withValues(alpha: 0.2), width: 2),
        ),
        child: Row(
          children: [
            Icon(Icons.location_on, color: accent, size: 22),
            const SizedBox(width: 10),

            Expanded(
              child: Text(
                displayText,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: displayText == 'Select location'
                      ? Colors.grey
                      : theme.textTheme.bodyLarge?.color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[500]),
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
                      // Update provider
                      ref.read(locationProvider.notifier).selectCity(city);

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
