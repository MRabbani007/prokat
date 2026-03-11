import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      await ref.read(ownerEquipmentProvider.notifier).createEquipment({
        "name": _name.text,
        "model": _model.text,
        "capacity": _capacity.text,
        "rentCondition": _rentCondition.text,
        "ownerComment": _ownerComment.text,
      });

      if (mounted) context.pop();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Equipment")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: _model,
                decoration: const InputDecoration(labelText: "Model"),
              ),
              TextFormField(
                controller: _capacity,
                decoration: const InputDecoration(labelText: "Capacity"),
              ),
              TextFormField(
                controller: _rentCondition,
                decoration: const InputDecoration(labelText: "Rent Condition"),
              ),
              TextFormField(
                controller: _ownerComment,
                decoration: const InputDecoration(labelText: "Comment"),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const CircularProgressIndicator()
                    : const Text("Create"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
