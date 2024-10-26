import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:thirst_quest/api/api_client.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';

class WaterBubblerService {
  final _apiClient = ApiClient();
  LatLngBounds? _loadedBounds;
  List<WaterBubbler> _loadedBubblers = [];

  Future<List<WaterBubbler>> getWaterBubblersByBBox(LatLngBounds bounds) async {
    if (_loadedBounds != null && _loadedBounds!.containsBounds(bounds)) {
      return _filterBubblersInBounds(_loadedBubblers, bounds);
    }

    return _filterBubblersInBounds(await _loadBubblers(bounds), bounds);
  }

  LatLngBounds _extendBounds(LatLngBounds bounds) {
    final latDiff = bounds.north - bounds.south;
    final lonDiff = bounds.east - bounds.west;

    final extendedSw = LatLng(bounds.south - latDiff, bounds.west - lonDiff);
    final extendedNe = LatLng(bounds.north + latDiff, bounds.east + lonDiff);

    return LatLngBounds(extendedSw, extendedNe);
  }

  Future<List<WaterBubbler>> _loadBubblers(LatLngBounds bounds) async {
    final extendedBounds = _extendBounds(bounds);
    final newBubblers = await _apiClient.getBubblersByBBox(
      extendedBounds.south,
      extendedBounds.north,
      extendedBounds.west,
      extendedBounds.east,
    );

    _loadedBubblers = newBubblers;
    _loadedBounds = extendedBounds;

    return newBubblers;
  }

  List<WaterBubbler> _filterBubblersInBounds(
      List<WaterBubbler> waterBubblers, LatLngBounds bounds) {
    return waterBubblers
        .where((bubbler) => bounds.contains(bubbler.position))
        .toList();
  }
}
