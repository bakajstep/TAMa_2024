import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class BubblerMapState extends ChangeNotifier {
  final MapController _mapController = MapController();
  bool _trackPosition = true;
  bool _showPositionMarker = false;
  LatLng? _currentPosition;

  MapController get mapController => _mapController;

  bool get showPositionMarker => _showPositionMarker;

  bool get trackPosition => _trackPosition;

  LatLng? get currentPosition => _currentPosition;

  set trackPosition(bool value) {
    _trackPosition = value;
    notifyListeners();
  }

  void changeLocation(LatLng position, bool isGpsLocation, bool forceTracking) {
    _updateLocation(position, isGpsLocation, forceTracking, null);
  }

  void changeLocationAndRotation(LatLng position, bool isGpsLocation,
      bool forceTracking, double rotation) {
    _updateLocation(position, isGpsLocation, forceTracking, rotation);
  }

  void _updateLocation(LatLng position, bool isGpsLocation, bool forceTracking,
      double? rotation) {
    if (isGpsLocation != _showPositionMarker) {
      _showPositionMarker = isGpsLocation;
      notifyListeners();
    }

    _trackPosition = _trackPosition || forceTracking;
    _currentPosition = position;
    if (_trackPosition) {
      if (rotation != null) {
        _mapController.moveAndRotate(position, 15.0, rotation);
        return;
      }
      _mapController.move(position, 15.0);
    }
  }
}
