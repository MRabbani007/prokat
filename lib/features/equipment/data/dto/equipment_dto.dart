import 'package:json_annotation/json_annotation.dart';
import 'package:prokat/features/equipment/domain/equipment.dart';

part 'equipment_dto.g.dart';

@JsonSerializable()
class EquipmentDto {
  final String id;
  final String name;
  final int price;

  EquipmentDto({required this.id, required this.name, required this.price});

  factory EquipmentDto.fromJson(Map<String, dynamic> json) =>
      _$EquipmentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EquipmentDtoToJson(this);

  Equipment toDomain() {
    return Equipment(id: id, name: name, price: price);
  }
}
