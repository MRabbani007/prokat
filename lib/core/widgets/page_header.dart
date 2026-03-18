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
        left: 70,    // Clears the FAB on the top-left
        right: 20,
        bottom: 12,  // Spacing before the content starts
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700, // Not "Black", but a solid Bold
          color: Color.fromARGB(255, 221, 224, 228),    // Deep charcoal, much richer than black87 0xFF1A1C1E
          letterSpacing: -0.5,         // Tightening the letters makes it look modern
        ),
      ),
    );
  }
}
