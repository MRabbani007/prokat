import 'package:flutter/material.dart';

class PhoneRegisterForm extends StatelessWidget {
  const PhoneRegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Column(
      children: [
        const SizedBox(height: 40),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: "Phone Number",
            prefixIcon: const Icon(Icons.phone_android_outlined),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: () {},
          child: const Text("SEND CODE", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
