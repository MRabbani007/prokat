import 'package:flutter/material.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // Define theme constants locally or use your global ones
    const ghostGray = Color(0x4DFFFFFF); // White @ 30%

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Get Started",
          style: TextStyle(
            color: Colors.white, // Pop against bgColor
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: -1,
          ),
        ),
        SizedBox(height: 4), // Tight industrial spacing
        Text(
          "Select your preferred registration method",
          style: TextStyle(color: ghostGray, fontSize: 16),
        ),
      ],
    );
  }
}
