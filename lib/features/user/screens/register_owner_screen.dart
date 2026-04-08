import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterOwnerPage extends ConsumerStatefulWidget {
  const RegisterOwnerPage({super.key});

  @override
  ConsumerState<RegisterOwnerPage> createState() => _RegisterOwnerPageState();
}

class _RegisterOwnerPageState extends ConsumerState<RegisterOwnerPage> {
  final fullNameController = TextEditingController();
  final iinController = TextEditingController();
  final displayNameController = TextEditingController();
  final paymentController = TextEditingController();

  final List<String> equipment = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register as Owner")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 BASIC INFO
            _sectionTitle(context, "Basic Information"),

            const SizedBox(height: 12),
            _inputField(controller: fullNameController, hint: "Full Name"),

            const SizedBox(height: 12),
            _inputField(
              controller: iinController,
              hint: "IIN",
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 12),
            _inputField(
              controller: displayNameController,
              hint: "Display Name",
            ),

            const SizedBox(height: 28),

            /// 🔹 PAYMENT
            _sectionTitle(context, "Payment Details"),

            const SizedBox(height: 12),
            _inputField(
              controller: paymentController,
              hint: "IBAN / Card Number",
            ),

            const SizedBox(height: 28),

            /// 🔹 EQUIPMENT
            _sectionTitle(context, "Equipment"),

            const SizedBox(height: 12),

            ...equipment.map((e) => _equipmentTile(e)),

            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  equipment.add("New Equipment ${equipment.length + 1}");
                });
              },
              icon: const Icon(Icons.add),
              label: const Text("Add Equipment"),
            ),

            const SizedBox(height: 32),

            /// 🔹 CTA
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: submit logic
                },
                child: const Text("REGISTER OWNER"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Section Title
  Widget _sectionTitle(BuildContext context, String text) {
    final theme = Theme.of(context);

    return Text(
      text.toUpperCase(),
      style: theme.textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  /// 🔹 Input Field (uses your theme)
  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(hintText: hint),
    );
  }

  /// 🔹 Equipment Tile
  Widget _equipmentTile(String name) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.3),
      ),
      child: ListTile(
        title: Text(name),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () {
            setState(() {
              equipment.remove(name);
            });
          },
        ),
      ),
    );
  }
}
