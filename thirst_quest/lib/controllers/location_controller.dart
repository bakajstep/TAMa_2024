import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:thirst_quest/services/location_service.dart';

class LocationController {
  // Default position (VUT FIT)
  LatLng _currentPosition = const LatLng(49.2273106, 16.5983539);
  StreamSubscription<Position>? _positionStream;
  final LocationService _locationService = LocationService();

  bool isLocationServiceEnabled = false;
  LatLng get currentPosition => _currentPosition;

  set initialLocation(LatLng initialLocation) {
    _currentPosition = initialLocation;
  }

  void dispose() {
    _locationService.saveLastKnownPosition(_currentPosition);
    _positionStream?.cancel();
  }

  Future<void> startLocationStreamIfAvailable(Function(LatLng, bool) onChange) async {
    LatLng? lastKnownPosition = await _locationService.getLastKnownPosition();
    final bool isGpsLocation = await _locationService.isLocationServiceEnabled();
    _currentPosition = lastKnownPosition ?? _currentPosition;
    onChange(_currentPosition, isGpsLocation && lastKnownPosition != null);

    if (isGpsLocation) {
      isLocationServiceEnabled = true;
      _startLocationUpdates(onChange);
    }
  }

  void _startLocationUpdates(Function(LatLng, bool) onChange) {
    _positionStream = _locationService.getPositionStream().listen((Position position) {
      _currentPosition = LatLng(position.latitude, position.longitude);
      onChange(_currentPosition, true);
    });
  }
}
