// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_bubbler.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WaterBubbler _$WaterBubblerFromJson(Map<String, dynamic> json) => WaterBubbler(
      id: json['id'] as String?,
      osmId: (json['osmId'] as num?)?.toInt(),
      name: json['name'] as String?,
      desc: json['desc'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      upvoteCount: (json['upvoteCount'] as num).toInt(),
      downvoteCount: (json['downvoteCount'] as num).toInt(),
      photos: (json['photos'] as List<dynamic>?)
          ?.map((e) => Photo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WaterBubblerToJson(WaterBubbler instance) =>
    <String, dynamic>{
      'id': instance.id,
      'osmId': instance.osmId,
      'name': instance.name,
      'desc': instance.desc,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'upvoteCount': instance.upvoteCount,
      'downvoteCount': instance.downvoteCount,
      'photos': instance.photos,
    };
