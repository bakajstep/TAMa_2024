import 'package:geolocator/geolocator.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:thirst_quest/api/models/photo.dart';

part 'water_bubbler.g.dart';

@JsonSerializable()
class WaterBubbler {
  final String? id;
  final int? openStreetId;
  final String? name;
  final String? desc;
  final double latitude;
  final double longitude;
  final List<Photo> photos;
  final LatLng position;

  WaterBubbler({
    required this.id,
    required this.openStreetId,
    required this.name,
    required this.desc,
    required this.latitude,
    required this.longitude,
    List<Photo>? photos,
  })  : photos = photos ?? <Photo>[],
        position = LatLng(latitude, longitude);

  factory WaterBubbler.fromJson(Map<String, dynamic> json) =>
      _$WaterBubblerFromJson(json);

  Map<String, dynamic> toJson() => _$WaterBubblerToJson(this);

  double distanceTo(LatLng position) => Geolocator.distanceBetween(
      latitude, longitude, position.latitude, position.longitude);

  @override
  bool operator ==(Object other) =>
      other is WaterBubbler &&
      id == other.id &&
      openStreetId == other.openStreetId;

  @override
  int get hashCode => id.hashCode ^ openStreetId.hashCode;
}
