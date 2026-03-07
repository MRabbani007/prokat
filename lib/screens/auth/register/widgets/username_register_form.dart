import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/auth/providers/auth_provider.dart';

class UserNameRegisterForm extends ConsumerStatefulWidget {
  const UserNameRegisterForm({super.key});

  @override
  ConsumerState<UserNameRegisterForm> createState() =>
      _UserNameRegisterFormState();
}

class _UserNameRegisterFormState extends ConsumerState<UserNameRegisterForm> {
  final nameController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;

  Future<void> _register() async {
    setState(() => loading = true);

    try {
      await ref
          .read(authProvider.notifier)
          .register(
            firstName: nameController.text.split(" ")[0],
            lastName: nameController.text.split(" ")[1],
            username: userNameController.text,
            password: passwordController.text,
          );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40),

          _field("Full Name", Icons.person_outline, nameController),

          const SizedBox(height: 16),

          _field("Username", Icons.alternate_email, userNameController),

          const SizedBox(height: 16),

          _field(
            "Password",
            Icons.lock_outline,
            passwordController,
            isPassword: true,
          ),

          const SizedBox(height: 24),

          _button(),
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

  Widget _button() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 60),
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
