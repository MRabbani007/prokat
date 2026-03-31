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
    const accentColor = Color(0xFF4E73DF);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        disabledBackgroundColor: accentColor.withValues(alpha: 0.5),
        minimumSize: const Size(double.infinity, 56),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: loading ? null : onPressed,
      child: loading
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  loadingText.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            )
          : Text(
              text.toUpperCase(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
    );
  }
}
