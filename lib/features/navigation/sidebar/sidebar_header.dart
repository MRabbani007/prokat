import 'package:flutter/material.dart';

class SidebarHeader extends StatelessWidget {
  const SidebarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: 60,
        bottom: 24,
        left: 20,
        right: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.indigo.withAlpha(30),
        border: const Border(
          bottom: BorderSide(color: Colors.black12, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          /// APP ICON
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.indigo.withAlpha(90),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.precision_manufacturing_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),

          const SizedBox(width: 12),

          /// APP NAME
          const Text(
            'PROKAT',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}