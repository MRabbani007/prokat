import 'package:flutter/material.dart';

class OtpField extends StatelessWidget {
  final TextEditingController controller;

  const OtpField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      maxLength: 6,
      // Large bold text for the OTP numbers
      style: TextStyle(
        color: theme.primaryColor,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        letterSpacing: 8, // Spaced out for better readability
      ),
      cursorColor: const Color(0xFF4E73DF),
      decoration: InputDecoration(
        labelText: "OTP",
        labelStyle: TextStyle(
          color: theme.primaryColor,
          letterSpacing: 1.2,
          fontSize: 14,
        ),
        // floatingLabelStyle: const TextStyle(
        //   color: Colors.white,
        //   fontWeight: FontWeight.bold,
        //   backgroundColor: Colors.transparent, // Prevents the 'box' look
        // ),
        floatingLabelAlignment: FloatingLabelAlignment.center,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        counterText: "", // Hides the 0/6 counter
        filled: true,
        fillColor: theme.colorScheme.onSurface.withValues(alpha: 0.08),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
        ),
        // focusedBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(12),
        //   borderSide: BorderSide(
        //     color: theme.colorScheme.outline.withValues(alpha: 0.2),
        //     width: 1.5,
        //   ),
        // ),
        contentPadding: const EdgeInsets.symmetric(vertical: 20),
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(16),
        //   borderSide: BorderSide.none,
        // ),
      ),
    );
  }
}
