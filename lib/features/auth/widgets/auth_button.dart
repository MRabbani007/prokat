import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final bool loading;
  final String text;
  final String loadingText;
  final VoidCallback onPressed;

  const AuthButton({
    super.key,
    required this.loading,
    required this.text,
    required this.loadingText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onPressed: loading ? null : onPressed,
      child: Text(
        loading ? loadingText : text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}