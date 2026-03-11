import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/auth/providers/auth_provider.dart';

class RegisterWithUsernameForm extends ConsumerStatefulWidget {
  const RegisterWithUsernameForm({super.key});

  @override
  ConsumerState<RegisterWithUsernameForm> createState() =>
      _RegisterWithUsernameFormState();
}

class _RegisterWithUsernameFormState
    extends ConsumerState<RegisterWithUsernameForm> {
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    List<String> name = nameController.text.trim().split(" ");

    await ref
        .read(authProvider.notifier)
        .register(
          "PASSWORD",
          usernameController.text.trim(),
          passwordController.text,
          name[0],
          name.length > 1 ? name[1] : "",
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen(authProvider, (_, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error!)));
      }
    });

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40),

          _field("Full Name", Icons.person_outline, nameController),

          const SizedBox(height: 16),

          _field("Username", Icons.alternate_email, usernameController),

          const SizedBox(height: 16),

          _field(
            "Password",
            Icons.lock_outline,
            passwordController,
            isPassword: true,
          ),

          const SizedBox(height: 24),

          _button(authState.isLoading),
        ],
      ),
    );
  }

  Widget _field(
    String label,
    IconData icon,
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _button(bool loading) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      onPressed: loading ? null : _register,
      child: Text(
        loading ? "Creating..." : "CREATE ACCOUNT",
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
