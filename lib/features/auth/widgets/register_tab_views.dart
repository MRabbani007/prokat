import 'package:flutter/material.dart';
import 'package:prokat/features/auth/widgets/register_with_phone_form.dart';
import 'package:prokat/features/auth/widgets/register_with_username_form.dart';

class RegisterTabViews extends StatelessWidget {
  const RegisterTabViews({super.key});

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [RegisterWithPhoneForm(), RegisterWithUsernameForm()],
    );
  }
}
