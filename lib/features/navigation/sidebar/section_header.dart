import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 20, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.40),
          fontSize: 12,
          fontWeight: FontWeight.w300, // Light font as requested
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
