// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EquipmentDto _$EquipmentDtoFromJson(Map<String, dynamic> json) => EquipmentDto(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toInt(),
    );

Map<String, dynamic> _$EquipmentDtoToJson(EquipmentDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
    };
