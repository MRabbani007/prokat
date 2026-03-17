import 'package:flutter/material.dart';

class SidebarHeader extends StatelessWidget {
  const SidebarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // Matches the sidebar background for a seamless look
    const headerBg = Color(0xFF121417);
    const accentColor = Color(0xFF4E73DF); // A sharp, modern blue

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 64, bottom: 30, left: 24, right: 24),
      decoration: BoxDecoration(
        color: headerBg,
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          /// APP ICON - Using a gradient for depth
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [accentColor, accentColor.withValues(alpha: 0.7)],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.precision_manufacturing_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),

          const SizedBox(width: 16),

          /// APP NAME - Modern Typography
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'PROKAT',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.95),
                  fontSize: 22,
                  fontWeight: FontWeight.bold, // Extra bold for premium feel
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                'EQUIPMENT RENTAL',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
