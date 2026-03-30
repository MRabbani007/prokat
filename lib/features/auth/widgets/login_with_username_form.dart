import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/auth/models/auth_credentials.dart';
import 'package:prokat/features/auth/providers/auth_provider.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';
import 'package:go_router/go_router.dart';

class LoginWithUsernameForm extends ConsumerStatefulWidget {
  const LoginWithUsernameForm({super.key});

  @override
  ConsumerState<LoginWithUsernameForm> createState() =>
      _LoginWithUsernameFormState();
}

class _LoginWithUsernameFormState extends ConsumerState<LoginWithUsernameForm> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    try {
      final credentials = UsernamePasswordCredentials(
        username: usernameController.text.trim(),
        password: passwordController.text,
      );

      final res = await ref.read(authProvider.notifier).login(credentials);

      if (res == true) {
        context.push("/search/map");
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Column(
      children: [
        const SizedBox(height: 40),

        AuthTextField(
          label: "Username",
          icon: Icons.alternate_email,
          controller: usernameController,
        ),

        const SizedBox(height: 16),

        AuthTextField(
          label: "Password",
          icon: Icons.lock_outline,
          controller: passwordController,
          isPassword: true,
        ),

        const SizedBox(height: 24),

        AuthButton(
          loading: authState.isLoading,
          text: "LOGIN",
          loadingText: "Signing in...",
          onPressed: _login,
        ),
      ],
    );
  }
}
