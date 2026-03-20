import 'package:flutter/material.dart';

class PageHeader extends StatelessWidget {
  final String title;

  const PageHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20, // Spacing from the top SafeArea
        left: 80, // Clears the FAB on the top-left
        right: 20,
        bottom: 12, // Spacing before the content starts
      ),
      child: Align(
        alignment: Alignment.centerLeft, // ✅ guarantees left alignment
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color.fromARGB(255, 221, 224, 228),
            letterSpacing: -0.5,
          ),
        ),
      ),
    );
  }
}
