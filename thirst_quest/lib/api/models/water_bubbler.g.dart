// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_bubbler.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WaterBubbler _$WaterBubblerFromJson(Map<String, dynamic> json) => WaterBubbler(
      id: json['id'] as String?,
      osmId: (json['osmId'] as num?)?.toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      upvoteCount: (json['upvoteCount'] as num).toInt(),
      downvoteCount: (json['downvoteCount'] as num).toInt(),
      favorite: json['favorite'] as bool? ?? false,
      review: json['review'] == null
          ? null
          : Review.fromJson(json['review'] as Map<String, dynamic>),
      photos: (json['photos'] as List<dynamic>?)
          ?.map((e) => Photo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WaterBubblerToJson(WaterBubbler instance) =>
    <String, dynamic>{
      'id': instance.id,
      'osmId': instance.osmId,
      'name': instance.name,
      'description': instance.description,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'photos': instance.photos,
      'upvoteCount': instance.upvoteCount,
      'downvoteCount': instance.downvoteCount,
      'favorite': instance.favorite,
      'review': instance.review,
    };
