import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/core/constants/cities.dart';
import 'package:prokat/features/locations/state/location_provider.dart';
import 'package:prokat/features/user/state/user_profile_provider.dart';

class CityPickerSheet extends ConsumerWidget {
  final String? mode;
  final ScrollController scrollController;

  const CityPickerSheet({super.key, this.mode, required this.scrollController});

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
                controller: scrollController,
                shrinkWrap: true,
                itemCount: cities.length,
                separatorBuilder: (_, _) => const Divider(),
                itemBuilder: (context, index) {
                  final city = cities[index];

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
