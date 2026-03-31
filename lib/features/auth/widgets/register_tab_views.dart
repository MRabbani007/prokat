import 'package:flutter/material.dart';
import 'package:prokat/features/auth/widgets/register_with_phone_form.dart';
import 'package:prokat/features/auth/widgets/register_with_username_form.dart';

class RegisterTabViews extends StatelessWidget {
  final Function(String?)
  onError; // Callback to sync errors with the main screen

  const RegisterTabViews({super.key, required this.onError});

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      // Ensure the physics match the industrial feel
      physics: const BouncingScrollPhysics(),
      children: [
        // Both forms now receive the error handler
        RegisterWithPhoneForm(onError: onError),
        RegisterWithUsernameForm(onError: onError),
      ],
    );
  }
}
