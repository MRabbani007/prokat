import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterOwnerPage extends ConsumerStatefulWidget {
  const RegisterOwnerPage({super.key});

  @override
  ConsumerState<RegisterOwnerPage> createState() => _RegisterOwnerPageState();
}

class _RegisterOwnerPageState extends ConsumerState<RegisterOwnerPage> {
  final _formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final iinController = TextEditingController();
  final displayNameController = TextEditingController();
  final paymentController = TextEditingController();

  final List<String> equipment = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003893), // Match the dark blue header
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                      const Text(
                        "Become a provider",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Simple Stepper UI
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _stepCircle("1", "Business", true),
                      _stepLine(),
                      _stepCircle("2", "Licenses", false),
                      _stepLine(),
                      _stepCircle("3", "Documents", false),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Step 1 — Business information",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF003893),
                          ),
                        ),
                        const SizedBox(height: 20),

                        _buildInputField("Full name", "Aibek Tulegenov"),
                        _buildInputField(
                          "Business / company name",
                          "e.g. Aibek Transport LLP",
                        ),
                        _buildInputField(
                          "BIN / IIN (business ID number)",
                          "12-digit number",
                        ),

                        const Text(
                          "Operating region",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        _buildDropdownField("Atyrau region"),

                        const SizedBox(height: 24),
                        _buildInfoBox(),
                        const SizedBox(height: 40),

                        _buildNextButton(),
                      ],
                    ),
                  ),
                ),
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

Widget _stepCircle(String num, String label, bool isActive) {
  return Column(
    children: [
      CircleAvatar(
        radius: 15,
        backgroundColor: isActive ? Colors.white : Colors.white24,
        child: Text(
          num,
          style: TextStyle(
            color: isActive ? const Color(0xFF003893) : Colors.white,
          ),
        ),
      ),
      const SizedBox(height: 4),
      Text(label, style: const TextStyle(color: Colors.white, fontSize: 10)),
    ],
  );
}

Widget _stepLine() => Container(height: 1, width: 40, color: Colors.white24);

Widget _buildInputField(String label, String hint) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      TextFormField(
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
      const SizedBox(height: 16),
    ],
  );
}

Widget _buildDropdownField(String value) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(12),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        items: [
          value,
        ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (_) {},
      ),
    ),
  );
}

Widget _buildInfoBox() {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFE8F0FE),
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Row(
      children: [
        Icon(Icons.info_outline, color: Color(0xFF003893)),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            "Your application will be reviewed by our team. You remain a regular client until approved.",
            style: TextStyle(fontSize: 13, color: Color(0xFF003893)),
          ),
        ),
      ],
    ),
  );
}

Widget _buildNextButton() {
  return SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF003893),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {},
      child: const Text(
        "Next — Licenses",
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    ),
  );
}
