import 'package:flutter/material.dart';

class CenterPin extends StatelessWidget {
  const CenterPin({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: IgnorePointer(
        child: Icon(
          Icons.location_pin,
          size: 50,
          color: Colors.red,
        ),
      ),
    );
  }
}