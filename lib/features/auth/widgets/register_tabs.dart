import 'package:flutter/material.dart';

class RegisterTabs extends StatelessWidget {
  const RegisterTabs({super.key});

  @override
  Widget build(BuildContext context) {
    const ghostGray = Color(0x4DFFFFFF); // White @ 30%
    // const accentColor = Color(0xFF4E73DF);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        // Dark industrial container background
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        // The active tab "pill"
        indicator: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        labelColor: Colors.white,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          letterSpacing: 0.5,
        ),
        unselectedLabelColor: ghostGray,
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 14,
        ),
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'PHONE'),
          Tab(text: 'USERNAME'),
        ],
      ),
    );
  }
}
