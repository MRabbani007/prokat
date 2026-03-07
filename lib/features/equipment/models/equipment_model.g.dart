// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EquipmentModel _$EquipmentModelFromJson(Map<String, dynamic> json) =>
    EquipmentModel(
      id: json['id'] as String,
      name: json['name'] as String,
      model: json['model'] as String,
      price: (json['price'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      location: json['location'] as String,
      owner: json['owner'] as String,
      capacity: (json['capacity'] as num).toInt(),
      imageUrl: json['imageUrl'] as String,
      available: json['available'] as bool,
    );

Map<String, dynamic> _$EquipmentModelToJson(EquipmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'model': instance.model,
      'capacity': instance.capacity,
      'price': instance.price,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'location': instance.location,
      'owner': instance.owner,
      'imageUrl': instance.imageUrl,
      'available': instance.available,
    };
