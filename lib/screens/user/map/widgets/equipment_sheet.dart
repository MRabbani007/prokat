import 'package:flutter/material.dart';
import '../../../../features/equipment/models/equipment_model.dart';
import 'package:go_router/go_router.dart';

class EquipmentSheet extends StatelessWidget {
  final EquipmentModel equipment;

  const EquipmentSheet({super.key, required this.equipment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            equipment.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('Capacity: ${equipment.capacity} tons'),
          Text('Price: ₸${equipment.price.toInt()}'),
          Text(
            equipment.available ? 'Available' : 'Busy',
            style: TextStyle(
              color: equipment.available ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context.push('/equipment/${equipment.id}');
                  },
                  child: const Text('Details'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: equipment.available
                      ? () {
                          context.push('/equipment/${equipment.id}/book');
                        }
                      : null,
                  child: const Text('Book'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
