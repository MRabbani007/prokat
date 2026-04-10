import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final bool loading;
  final String text;
  final String loadingText;
  final VoidCallback onPressed;

  const AuthButton({
    super.key,
    required this.loading,
    required this.text,
    required this.loadingText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final primary = theme.colorScheme.primary;
    final onPrimary = theme.colorScheme.onPrimary;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        disabledBackgroundColor: primary.withValues(alpha: 0.5),
        minimumSize: const Size(double.infinity, 56),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: loading ? null : onPressed,
      child: loading
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: onPrimary,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  loadingText.toUpperCase(),
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                    color: onPrimary,
                  ),
                ),
              ],
            )
          : Text(
              text.toUpperCase(),
              style: theme.textTheme.labelLarge?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: onPrimary,
              ),
            ),
    );
  }
}
