import 'package:flutter/material.dart';

class EditSheet extends StatelessWidget {
  final String title;
  final String buttonText;
  final VoidCallback onSubmit;
  final Widget child;

  const EditSheet({
    super.key,
    required this.title,
    required this.onSubmit,
    required this.child,
    this.buttonText = "SAVE CHANGES",
  });

  @override
  Widget build(BuildContext context) {
    const bgColor = Color.fromARGB(255, 31, 34, 39); // Deep Midnight
    const accentBlue = Color(0xFF4E73DF); // Industrial Blue
    // const ghostGray = Color(0x4DFFFFFF); // White @ 30%

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)), // Large Item Radius
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.08), width: 1), // Rim Light top edge
        ),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Industrial Drag Handle
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 24),

            /// Technical Title Header
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 16),

            /// Custom Content (The Form Fields)
            child,

            const SizedBox(height: 40),

            /// Primary Action Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), // Small Item Radius
                  ),
                ),
                child: Text(
                  buttonText.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showEditSheet({
  required BuildContext context,
  required Widget sheet,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    // Add a slight barrier color to darken the background further
    barrierColor: Colors.black.withValues(alpha: 0.7),
    builder: (_) => sheet,
  );
}
