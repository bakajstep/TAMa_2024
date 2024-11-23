import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:thirst_quest/api/api_client.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';

class WaterBubblerService {
  final ApiClient apiClient;
  LatLngBounds? _loadedBounds;
  List<WaterBubbler> _loadedBubblers = [];

  WaterBubblerService({required this.apiClient});

  Future<List<WaterBubbler>> getWaterBubblersByBBox(
      {required LatLngBounds bounds, bool extendBounds = true}) async {
    if (_loadedBounds != null && _loadedBounds!.containsBounds(bounds)) {
      return _filterBubblersInBounds(_loadedBubblers, bounds);
    }

    return _filterBubblersInBounds(
        await _loadBubblers(bounds, extendBounds), bounds);
  }

  Future<List<WaterBubbler>> getXNearestBubblers(
      LatLng position, int count, LatLngBounds bounds) async {
    return (await getWaterBubblersByBBox(bounds: bounds, extendBounds: false))
      ..sort((a, b) => a.distanceTo(position).compareTo(b.distanceTo(position)))
      ..take(count).toList();
  }

  void clearCache() {
    _loadedBounds = null;
    _loadedBubblers = [];
  }

  LatLngBounds _extendBounds(LatLngBounds bounds) {
    final latDiff = bounds.north - bounds.south;
    final lonDiff = bounds.east - bounds.west;

    final extendedSw = LatLng(bounds.south - latDiff, bounds.west - lonDiff);
    final extendedNe = LatLng(bounds.north + latDiff, bounds.east + lonDiff);

    return LatLngBounds(extendedSw, extendedNe);
  }

  Future<List<WaterBubbler>> _loadBubblers(
      LatLngBounds bounds, bool extendBounds) async {
    final newBounds = extendBounds ? _extendBounds(bounds) : bounds;
    final newBubblers = await apiClient.getBubblersByBBox(
      newBounds.south,
      newBounds.north,
      newBounds.west,
      newBounds.east,
    );

    _loadedBubblers = newBubblers;
    _loadedBounds = newBounds;

    return newBubblers;
  }

  List<WaterBubbler> _filterBubblersInBounds(
      List<WaterBubbler> waterBubblers, LatLngBounds bounds) {
    return waterBubblers
        .where((bubbler) => bounds.contains(bubbler.position))
        .toList();
  }
}
