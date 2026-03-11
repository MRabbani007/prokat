import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/owner_equipment_provider.dart';

class EditEquipmentScreen extends ConsumerStatefulWidget {
  final String equipmentId;

  const EditEquipmentScreen({super.key, required this.equipmentId});

  @override
  ConsumerState<EditEquipmentScreen> createState() =>
      _EditEquipmentScreenState();
}

class _EditEquipmentScreenState
    extends ConsumerState<EditEquipmentScreen> {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _model = TextEditingController();
  final _capacity = TextEditingController();
  final _rentCondition = TextEditingController();
  final _ownerComment = TextEditingController();

  bool _loading = false;

  @override
  void initState() {
    super.initState();

    final equipment = ref
        .read(ownerEquipmentProvider)
        .equipment
        .firstWhere((e) => e.id == widget.equipmentId);

    _name.text = equipment.name;
    _model.text = equipment.model;
    _capacity.text = equipment.capacity;
    _rentCondition.text = equipment.rentCondition;
    _ownerComment.text = equipment.ownerComment ?? "";
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      await ref.read(ownerEquipmentProvider.notifier).updateEquipment(
        widget.equipmentId,
        {
          "name": _name.text,
          "model": _model.text,
          "capacity": _capacity.text,
          "rentCondition": _rentCondition.text,
          "ownerComment": _ownerComment.text,
        },
      );

      if (mounted) context.pop();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() => _loading = false);
  }

  Future<void> _delete() async {
    await ref
        .read(ownerEquipmentProvider.notifier)
        .deleteEquipment(widget.equipmentId);

    if (mounted) context.go('/owner/equipment');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Equipment")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: "Name"),
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
                decoration:
                    const InputDecoration(labelText: "Rent Condition"),
              ),
              TextFormField(
                controller: _ownerComment,
                decoration:
                    const InputDecoration(labelText: "Owner Comment"),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: const Text("Update"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red),
                onPressed: _delete,
                child: const Text("Delete"),
              )
            ],
          ),
        ),
      ),
    );
  }
}