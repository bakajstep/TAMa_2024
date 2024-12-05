// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

City _$CityFromJson(Map<String, dynamic> json) => City(
      name: json['name'] as String,
      countryCode: json['countryCode'] as String,
      lat: json['lat'] as String,
      lng: json['lng'] as String,
    );

Map<String, dynamic> _$CityToJson(City instance) => <String, dynamic>{
      'name': instance.name,
      'countryCode': instance.countryCode,
      'lat': instance.lat,
      'lng': instance.lng,
    };
