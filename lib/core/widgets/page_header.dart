import 'package:flutter/material.dart';

class PageHeader extends StatelessWidget {
  final String title;

  const PageHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,     // Spacing from the top SafeArea
        left: 90,    // Clears the FAB on the top-left
        right: 20,
        bottom: 12,  // Spacing before the content starts
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700, // Not "Black", but a solid Bold
          color: Color(0xFF1A1C1E),    // Deep charcoal, much richer than black87
          letterSpacing: -0.5,         // Tightening the letters makes it look modern
        ),
      ),
    );
  }
}
