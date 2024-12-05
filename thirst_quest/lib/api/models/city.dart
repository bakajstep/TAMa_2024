import 'package:json_annotation/json_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'city.g.dart';

@JsonSerializable()
class City {
  final String name;
  final String countryCode;
  final double lat;
  final double lng;
  final LatLng position;

  City({
    required this.name,
    required this.countryCode,
    required String lat,
    required String lng,
  })  : position = LatLng(double.parse(lat), double.parse(lng)),
        lat = double.parse(lat),
        lng = double.parse(lng);

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);

  Map<String, dynamic> toJson() => _$CityToJson(this);
}
