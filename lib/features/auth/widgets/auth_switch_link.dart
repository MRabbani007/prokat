import 'package:flutter/material.dart';

class AuthSwitchLink extends StatelessWidget {
  final String message;
  final String actionText;
  final VoidCallback onTap;

  const AuthSwitchLink({
    super.key,
    required this.message,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const ghostGray = Color(0x4DFFFFFF); // White @ 30%
    const accentColor = Color(0xFF4E73DF);

    return Padding(
      padding: const EdgeInsets.only(bottom: 24, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, style: const TextStyle(color: ghostGray, fontSize: 14)),
          GestureDetector(
            onTap: onTap,
            behavior:
                HitTestBehavior.opaque, // Makes the touch area more reliable
            child: Text(
              actionText,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: accentColor,
                fontSize: 14,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
