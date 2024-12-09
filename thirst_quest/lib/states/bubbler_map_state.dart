import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';
import 'package:thirst_quest/assets/constants.dart' as constants;
import 'package:thirst_quest/utils/animataion_ticker_provider.dart';

class BubblerMapState extends ChangeNotifier {
  final MapController _mapController = MapController();
  final double targetDetailZoom = 17.0;
  bool reloadBubblersOnMove = true;
  double _mapPixelOffset = 0.0;

  bool _filterFavorites = false;
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

  List<WaterBubbler> get waterBubblers =>
      _filterFavorites ? _waterBubblers.where((b) => b.favorite).toList() : _waterBubblers;

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

  set filterFavorites(bool value) {
    _filterFavorites = value;
    notifyListeners();
  }

  void toggleFavoritesFilter() {
    _filterFavorites = !_filterFavorites;
    notifyListeners();
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
      _animatedMapMove(position: position, rotation: rotation);
      return;
    }

    _animatedMapMove(position: position);
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

    _animatedMapMove(position: movedPosition);
  }

  void _animatedMapMove({required LatLng position, double? rotation}) {
    final latTween = Tween<double>(begin: mapController.camera.center.latitude, end: position.latitude);
    final lngTween = Tween<double>(begin: mapController.camera.center.longitude, end: position.longitude);
    final zoomTween = Tween<double>(begin: mapController.camera.zoom, end: targetDetailZoom);

    Tween<double>? rotationTween;
    if (rotation != null) {
      rotationTween = Tween<double>(begin: mapController.camera.rotation, end: rotation);
    }

    final controller = AnimationController(
        duration: const Duration(milliseconds: constants.longAnimationDuration), vsync: AnimationTickerProvider());

    final Animation<double> animation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      if (rotationTween != null) {
        mapController.moveAndRotate(LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
            zoomTween.evaluate(animation), rotationTween.evaluate(animation));
        return;
      }

      mapController.move(
          LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)), zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }
}
