import 'package:flutter/material.dart';

class IndustrialTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final int maxLines;
  final TextInputType keyboardType;

  /// 🔥 ADD THIS
  final Function(String)? onChanged;

  const IndustrialTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2125),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),

        /// 🔥 CONNECT HERE
        onChanged: onChanged,

        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.4),
            fontSize: 14,
          ),
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.15),
            fontSize: 14,
          ),
          prefixIcon: Icon(icon, color: const Color(0xFF4E73DF), size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          floatingLabelStyle: const TextStyle(color: Color(0xFF4E73DF)),
        ),
      ),
    );
  }
}
