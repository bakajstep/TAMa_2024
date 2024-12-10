import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:thirst_quest/api/models/review.dart';
import 'package:thirst_quest/api/thirst_quest_api_client.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';
import 'package:thirst_quest/services/auth_service.dart';
import 'package:thirst_quest/utils/cache.dart';

class WaterBubblerService {
  static const bubblersKey = 'bubblers';
  static const bubblersBoundsKey = 'bubblers_bounds';

  final ThirstQuestApiClient apiClient;
  final AuthService authService;
  final Cache cache;

  WaterBubblerService({required this.apiClient, required this.authService, required this.cache});

  Future<List<WaterBubbler>> getWaterBubblersByBBox({required LatLngBounds bounds, bool extendBounds = true}) async {
    final loadedBounds = cache.get<LatLngBounds?>(bubblersBoundsKey);

    if (loadedBounds != null && loadedBounds.containsBounds(bounds)) {
      final loadedBubblers = cache.get<List<WaterBubbler>>(bubblersKey);

      return _filterBubblersInBounds(loadedBubblers ?? [], bounds);
    }

    return _filterBubblersInBounds(await _loadBubblers(bounds, extendBounds), bounds);
  }

  Future<List<WaterBubbler>> getNearestBubblers(LatLng position, LatLngBounds bounds) async {
    return (await getWaterBubblersByBBox(bounds: bounds, extendBounds: false))
      ..sort((a, b) => a.distanceTo(position).compareTo(b.distanceTo(position)))
      ..toList();
  }

  Future<void> toggleFavorite(WaterBubbler waterBubbler) async {
    final token = await authService.getToken();
    waterBubbler.favorite
        ? await apiClient.removeFromFavorites(token, waterBubbler.id, waterBubbler.osmId)
        : await apiClient.addToFavorites(token, waterBubbler.id, waterBubbler.osmId);

    waterBubbler.favorite = !waterBubbler.favorite;
  }

  Future<void> addReview(Review review) async {
    final token = await authService.getToken();
    await apiClient.addReview(token, review);
  }

  Future<void> deleteReview(String? bubblerId, int? bubblerOsmId) async {
    final token = await authService.getToken();
    await apiClient.deleteReview(token, bubblerId, bubblerOsmId);
  }

  Future<void> updateReview(Review review) async {
    final token = await authService.getToken();
    await apiClient.updateReview(token, review);
  }

  Future<List<WaterBubbler>> getWaterBubblerCreatedByUser() async {
    final token = await authService.getToken();
    return apiClient.getWaterBubblersCreatedByUser(token);
  }

  Future<List<WaterBubbler>> getUsersFavoriteWaterBubblers() async {
    final token = await authService.getToken();
    return apiClient.getUsersFavoriteWaterBubblers(token);
  }

  Future<void> deleteWaterBubbler(String bubblerId) async {
    final token = await authService.getToken();
    cache.clear(); // Clear cache to force reload of bubblers
    apiClient.deleteWaterBubbler(token, bubblerId);
  }

  Future<WaterBubbler> createWaterBubbler(WaterBubbler bubbler) async {
    final token = await authService.getToken();
    cache.clear(); // Clear cache to force reload of bubblers
    return apiClient.createWaterBubbler(token, bubbler);
  }

  Future<void> updateWaterBubbler(WaterBubbler bubbler) async {
    final token = await authService.getToken();
    return apiClient.updateWaterBubbler(token, bubbler);
  }

  LatLngBounds _extendBounds(LatLngBounds bounds) {
    final latDiff = bounds.north - bounds.south;
    final lonDiff = bounds.east - bounds.west;

    final extendedSw = LatLng(bounds.south - latDiff, bounds.west - lonDiff);
    final extendedNe = LatLng(bounds.north + latDiff, bounds.east + lonDiff);

    return LatLngBounds(extendedSw, extendedNe);
  }

  Future<List<WaterBubbler>> _loadBubblers(LatLngBounds bounds, bool extendBounds) async {
    final token = await authService.tryGetToken();
    final newBounds = extendBounds ? _extendBounds(bounds) : bounds;

    final newBubblers =
        await apiClient.getBubblersByBBox(newBounds.south, newBounds.north, newBounds.west, newBounds.east, token);

    cache.set(bubblersKey, newBubblers);
    cache.set(bubblersBoundsKey, newBounds);

    return newBubblers;
  }

  List<WaterBubbler> _filterBubblersInBounds(List<WaterBubbler> waterBubblers, LatLngBounds bounds) {
    return waterBubblers.where((bubbler) => bounds.contains(bubbler.position)).toList();
  }
}
