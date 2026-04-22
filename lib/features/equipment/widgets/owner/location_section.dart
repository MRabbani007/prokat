import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/core/constants/cities.dart';
import 'package:prokat/core/widgets/inline_tile.dart';
import 'package:prokat/features/equipment/models/equipment_model.dart';
import 'package:prokat/features/equipment/providers/equipment_provider.dart';

class LocationSection extends StatefulWidget {
  final Equipment equipment;
  final String? location;
  final VoidCallback onAction;
  final WidgetRef ref;

  const LocationSection({
    super.key,
    required this.equipment,
    required this.location,
    required this.onAction,
    required this.ref,
  });

  @override
  State<LocationSection> createState() => _LocationSectionState();
}

class _LocationSectionState extends State<LocationSection> {
  late TextEditingController _cityController;

  bool _isDirty = false;
  bool _isSaving = false;

  Future<void> _handleSave() async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    try {
      final res = await widget.ref
          .read(equipmentProvider.notifier)
          .updateEquipmentLocation(widget.equipment.id, {
            "id": widget.equipment.id,
            "city": _cityController.text.trim(),
          });

      if (mounted && res == true) {
        setState(() {
          _isDirty = false;
          _isSaving = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Equipment Updated"),
            backgroundColor: colorScheme.primary,
          ),
        );
      } else {
        setState(() {
          _isDirty = true;
          _isSaving = false;
        });
      }
    } catch (_) {
      setState(() => _isSaving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Update Failed"),
          backgroundColor: colorScheme.error,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    _cityController = TextEditingController(text: widget.equipment.city);
  }

  void _selectCity(String city) {
    _cityController.text = city;
    if (!_isDirty && city != widget.equipment.city) {
      setState(() => _isDirty = true);
    }
    Navigator.pop(context); // Close the sheet
    setState(() {}); // Refresh the UI (icons/colors)
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final accent = colorScheme.primary;
    final warning = colorScheme.tertiary;

    final location = widget.location;
    final bool hasLocation = location != null && location.isNotEmpty;

    return InlineTile(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("LOCATION", style: theme.textTheme.titleLarge),
              _isDirty
                  ? TextButton.icon(
                      onPressed: _isSaving ? null : _handleSave,
                      icon: _isSaving
                          ? SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colorScheme.onPrimary,
                              ),
                            )
                          : const Icon(Icons.save_rounded, size: 16),
                      label: const Text("Save"),
                      style: TextButton.styleFrom(
                        foregroundColor: colorScheme.onPrimary,
                        backgroundColor: accent,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        Icons.lock_outline_rounded,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        size: 18,
                      ),
                    ),
            ],
          ),

          SizedBox(height: 12),

          ValueListenableBuilder(
            valueListenable: _cityController,
            builder: (context, value, child) {
              // Check if the text is not empty to determine 'hasLocation'
              final bool hasLocation = value.text.isNotEmpty;

              return GestureDetector(
                onTap: () {
                  // Logic: If list has 1 value, take it. Otherwise, take the first.
                  // final String defaultCity = cities.length == 1
                  //     ? cities.first
                  //     : cities[0];

                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Select City",
                              style: theme.textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 10),
                            ...cities.map(
                              (city) => ListTile(
                                title: Text(city),
                                leading: const Icon(Icons.location_city),
                                trailing: _cityController.text == city
                                    ? Icon(Icons.check_circle, color: accent)
                                    : null,
                                onTap: () => _selectCity(city),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        hasLocation ? Icons.pin_drop : Icons.pin_drop_outlined,
                        color: hasLocation ? accent : warning,
                        size: 26,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "City",
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              hasLocation
                                  ? value.text
                                  : "Select City", // Fallback text
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: hasLocation
                                    ? colorScheme.onSurface
                                    : warning,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 12),

          /// CONTENT
          GestureDetector(
            onTap: widget.onAction,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    hasLocation ? Icons.pin_drop : Icons.pin_drop_outlined,
                    color: hasLocation ? accent : warning,
                    size: 26,
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hasLocation ? "CURRENT LOCATION" : "ENTER LOCATION",
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          location ?? "Add a location to enable bookings",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: hasLocation
                                ? colorScheme.onSurface
                                : warning,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
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
