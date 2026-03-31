import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType? keyboardType;

  const AuthTextField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    this.isPassword = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ), // Light text for dark BG
      cursorColor: const Color(0xFF4E73DF), // Using your accentColor
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Color(0x4DFFFFFF),
        ), // ghostGray (30% white)
        prefixIcon: Icon(icon, size: 20, color: const Color(0x4DFFFFFF)),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05), // Dark industrial fill
        // Default border
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        // Focused state border
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4E73DF), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 16,
        ),
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(16),
        //   borderSide: BorderSide.none,
        // ),
      ),
    );
  }
}
