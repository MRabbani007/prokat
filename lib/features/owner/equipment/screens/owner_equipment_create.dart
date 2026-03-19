import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/core/widgets/page_header.dart';
import '../providers/owner_equipment_provider.dart';

class CreateEquipmentScreen extends ConsumerStatefulWidget {
  const CreateEquipmentScreen({super.key});

  @override
  ConsumerState<CreateEquipmentScreen> createState() =>
      _CreateEquipmentScreenState();
}

class _CreateEquipmentScreenState extends ConsumerState<CreateEquipmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _model = TextEditingController();
  final _capacity = TextEditingController();
  final _rentCondition = TextEditingController();
  final _ownerComment = TextEditingController();

  bool _loading = false;

  // Industrial Palette Constants
  static const bgColor = Color(0xFF121417);
  static const cardColor = Color(0xFF1E2125);
  static const accentBlue = Color(0xFF4E73DF);
  static const ghostGray = Color(0x4DFFFFFF);

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      await ref.read(ownerEquipmentProvider.notifier).createEquipment({
        "name": _name.text.trim(),
        "model": _model.text.trim(),
        "capacity": int.tryParse(_capacity.text.trim()) ?? 0,
        "rentCondition": _rentCondition.text.trim(),
        "ownerComment": _ownerComment.text.trim(),
      });
      if (mounted) context.pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFD97706),
          content: Text("SYSTEM ERROR: ${e.toString().toUpperCase()}"),
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Signature Page Header
            PageHeader(title: "Add Equipment"),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const Text(
                      //   "ASSET TELEMETRY & SPECIFICATIONS",
                      //   style: TextStyle(
                      //     color: ghostGray,
                      //     fontSize: 10,
                      //     fontWeight: FontWeight.bold,
                      //     letterSpacing: 1.5,
                      //   ),
                      // ),
                      const SizedBox(height: 12),

                      // 2. Main Industrial Input Panel
                      Container(
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        child: Column(
                          children: [
                            _AssetInputField(
                              label: "EQUIPMENT NAME",
                              controller: _name,
                              hint: "e.g. Septic Truck",
                              validator: (v) => v!.isEmpty ? "REQUIRED" : null,
                            ),
                            _AssetInputField(
                              label: "MODEL NUMBER",
                              controller: _model,
                              hint: "e.g. KAMAZ-65115",
                            ),
                            _AssetInputField(
                              label: "UNIT CAPACITY",
                              controller: _capacity,
                              hint: "0",
                              isNumeric: true,
                            ),
                            _AssetInputField(
                              label: "RENTAL CONDITIONS",
                              controller: _rentCondition,
                              hint: "Terms of service...",
                            ),
                            _AssetInputField(
                              label: "ADMINISTRATIVE COMMENT",
                              controller: _ownerComment,
                              hint: "Internal notes...",
                              isLast: true,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // 3. Status Indicator
                      Center(
                        child: Text(
                          _loading
                              ? "Saving..."
                              : "",
                          style: TextStyle(
                            color: _loading ? accentBlue : ghostGray,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 4. Primary Action Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentBlue,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: accentBlue.withOpacity(
                              0.3,
                            ),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: _loading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  "Add",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable Industrial Input for the Creation Screen
class _AssetInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final bool isNumeric;
  final bool isLast;
  final String? Function(String?)? validator;

  const _AssetInputField({
    required this.label,
    required this.controller,
    required this.hint,
    this.isNumeric = false,
    this.isLast = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0x4DFFFFFF),
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextFormField(
            controller: controller,
            validator: validator,
            keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
            cursorColor: const Color(0xFF4E73DF),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.1),
                fontSize: 14,
              ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              border: InputBorder.none,
              errorStyle: const TextStyle(
                color: Color(0xFFD97706),
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
