import 'package:flutter/material.dart';

class DeleteEquipmentSection extends StatelessWidget {
  final VoidCallback onDelete;

  const DeleteEquipmentSection({super.key, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    const warningAmber = Color(0xFFD97706);
    const ghostGray = Color(0x4DFFFFFF); // White @ 30%

    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 40),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2125), // Industrial Charcoal
        borderRadius: BorderRadius.circular(28), // Large Item Radius
        border: Border.all(
          // Warning Amber Rim Light
          color: warningAmber.withValues(alpha: 0.15), 
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Technical Warning Label
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.warning_amber_rounded, color: warningAmber, size: 16),
              const SizedBox(width: 8),
              Text(
                "DANGER ZONE",
                style: TextStyle(
                  color: warningAmber.withValues(alpha: 0.8),
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          const Text(
            "Deleting this asset will permanently remove all telemetry and pricing data from the fleet database.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ghostGray,
              fontSize: 12,
              height: 1.4,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Heavy-duty Destructive Button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: OutlinedButton.icon(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_forever_rounded, size: 20),
              label: const Text(
                "Delete Equipment",
                style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFEF4444), // Muted Destructive Red
                side: BorderSide(color: const Color(0xFFEF4444).withValues(alpha: 0.3)),
                backgroundColor: const Color(0xFFEF4444).withValues(alpha: 0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // Small Item Radius
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
