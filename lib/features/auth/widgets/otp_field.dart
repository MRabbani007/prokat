import 'package:flutter/material.dart';

class OtpField extends StatelessWidget {
  final TextEditingController controller;

  const OtpField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      maxLength: 6,
      // Large bold text for the OTP numbers
      style: const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        letterSpacing: 8, // Spaced out for better readability
      ),
      cursorColor: const Color(0xFF4E73DF),
      decoration: InputDecoration(
        labelText: "VERIFICATION CODE",
        labelStyle: const TextStyle(
          color: Color(0x4DFFFFFF), // ghostGray
          letterSpacing: 1.2,
          fontSize: 12,
        ),
        floatingLabelAlignment: FloatingLabelAlignment.center,
        counterText: "", // Hides the 0/6 counter
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4E73DF), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 20),
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(16),
        //   borderSide: BorderSide.none,
        // ),
      ),
    );
  }
}
