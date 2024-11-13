import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';

class BubblerMapState extends ChangeNotifier {
  final MapController _mapController = MapController();
  bool _trackPosition = true;
  bool _showPositionMarker = false;
  bool _reloadBubblersOnMove = true;
  LatLng? _currentPosition;
  WaterBubbler? _selectedBubbler;
  List<WaterBubbler> _waterBubblers = [];

  MapController get mapController => _mapController;

  bool get showPositionMarker => _showPositionMarker;

  bool get trackPosition => _trackPosition;

  bool get reloadBubblersOnMove => _reloadBubblersOnMove;

  LatLng? get currentPosition => _currentPosition;

  WaterBubbler? get selectedBubbler => _selectedBubbler;

  List<WaterBubbler> get waterBubblers => _waterBubblers;

  set trackPosition(bool value) {
    _trackPosition = value;
    notifyListeners();
  }

  set reloadBubblersOnMove(bool value) {
    _reloadBubblersOnMove = value;
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
