import 'package:flutter/material.dart';

class LanguageSelectorTile extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const LanguageSelectorTile({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
          style: theme.textTheme.bodyMedium?.copyWith(
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
