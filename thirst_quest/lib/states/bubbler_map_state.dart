import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';

class BubblerMapState extends ChangeNotifier {
  final MapController _mapController = MapController();
  final double targetDetailZoom = 15.0;
  bool reloadBubblersOnMove = true;
  double _mapPixelOffset = 0.0;

  bool _trackPosition = true;
  bool _showPositionMarker = false;
  LatLng? _currentPosition;
  WaterBubbler? _selectedBubbler;
  List<WaterBubbler> _waterBubblers = [];

  MapController get mapController => _mapController;

  bool get showPositionMarker => _showPositionMarker;

  bool get trackPosition => _trackPosition;

  LatLng? get currentPosition => _currentPosition;

  WaterBubbler? get selectedBubbler => _selectedBubbler;

  List<WaterBubbler> get waterBubblers => _waterBubblers;

  set trackPosition(bool value) {
    _trackPosition = value;
    notifyListeners();
  }

  set selectedBubbler(WaterBubbler? value) {
    _selectedBubbler = value;
    notifyListeners();
  }

  set waterBubblers(List<WaterBubbler> waterBubblers) {
    _waterBubblers = waterBubblers;
    notifyListeners();
  }

  set mapPixelOffset(double value) {
    _mapPixelOffset = value;
  }

  void changeLocation(LatLng position, bool isGpsLocation, bool forceTracking) {
    _updateLocation(position, isGpsLocation, forceTracking, null);
  }

  void changeLocationAndRotation(LatLng position, bool isGpsLocation, bool forceTracking, double rotation) {
    _updateLocation(position, isGpsLocation, forceTracking, rotation);
  }

  void _updateLocation(LatLng position, bool isGpsLocation, bool forceTracking, double? rotation) {
    if (isGpsLocation != _showPositionMarker) {
      _showPositionMarker = isGpsLocation;
      notifyListeners();
    }

    _trackPosition = _trackPosition || forceTracking;
    _currentPosition = position;
    if (!_trackPosition) {
      return;
    }

    if (rotation != null) {
      _mapController.moveAndRotate(position, targetDetailZoom, rotation);
      return;
    }

    _mapController.move(position, targetDetailZoom);
  }

  void mapMove(LatLng position) {
    final pixelOffset = Point(0.0, _mapPixelOffset);
    final crs = _mapController.camera.crs;
    final screenPoint = crs.latLngToPoint(position, targetDetailZoom);

    final offsetPoint = screenPoint + pixelOffset;
    final latLngOffset = crs.pointToLatLng(offsetPoint, targetDetailZoom);
    final movedPosition = LatLng(
      position.latitude - (latLngOffset.latitude - position.latitude),
      position.longitude - (latLngOffset.longitude - position.longitude),
    );

    _mapController.move(movedPosition, targetDetailZoom);
  }
}
