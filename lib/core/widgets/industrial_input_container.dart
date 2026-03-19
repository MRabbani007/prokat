import 'package:flutter/material.dart';

class IndustrialInputContainer extends StatelessWidget {
  final String label;
  final Widget child;

  const IndustrialInputContainer({super.key, required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2), // Inset Panel
        borderRadius: BorderRadius.circular(16), // Small Item Radius
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ), // Rim Light
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0x4DFFFFFF),
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          child,
        ],
      ),
    );
  }
}
