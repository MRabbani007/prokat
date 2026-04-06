import 'package:flutter/material.dart';

class LanguagePillSelector extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const LanguagePillSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = Colors.amber; // same orange as rating star

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: accent.withValues(alpha: 0.8), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          icon: const SizedBox.shrink(), // no arrow
          dropdownColor: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.1,
          ),
          items: const ['EN', 'RU', 'KZ']
              .map(
                (lang) => DropdownMenuItem(
                  value: lang,
                  child: Text(
                    lang,
                    style: TextStyle(
                      fontWeight: lang == value
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
        ),
      ),
    );
  }
}
