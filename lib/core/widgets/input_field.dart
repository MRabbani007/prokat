import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final bool isNumeric;
  final bool isLast;
  final String? suffixText;
  final String? Function(String?)? validator;

  const InputField({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
    this.isNumeric = false,
    this.isLast = false,
    this.validator,
    this.suffixText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.15),
                ),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Label
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),

          const SizedBox(height: 4),

          /// Input row
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  validator: validator,
                  keyboardType: isNumeric
                      ? TextInputType.number
                      : TextInputType.text,
                  cursorColor: colorScheme.primary,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    border: InputBorder.none,
                    errorStyle: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              /// Suffix
              if (suffixText != null)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    suffixText!,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
