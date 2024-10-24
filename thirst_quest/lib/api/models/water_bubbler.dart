import 'package:json_annotation/json_annotation.dart';
import 'package:thirst_quest/api/models/photo.dart';

part 'water_bubbler.g.dart';

@JsonSerializable()
class WaterBubbler {
  final String id;
  final int openStreetId;
  final String? name;
  final String? desc;
  final double latitude;
  final double longitude;
  final List<Photo> photos;

  WaterBubbler({
    required this.id,
    required this.openStreetId,
    required this.name,
    required this.desc,
    required this.latitude,
    required this.longitude,
    List<Photo>? photos,
  }) : photos = photos ?? <Photo>[];

  factory WaterBubbler.fromJson(Map<String, dynamic> json) =>
      _$WaterBubblerFromJson(json);

  Map<String, dynamic> toJson() => _$WaterBubblerToJson(this);
}
