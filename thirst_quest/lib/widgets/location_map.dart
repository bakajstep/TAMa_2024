import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';
import 'package:thirst_quest/di.dart';
import 'package:thirst_quest/services/water_bubbler_service.dart';
import 'package:thirst_quest/widgets/map_control_buttons.dart';
import 'package:thirst_quest/widgets/map_widget.dart';
import 'package:thirst_quest/services/location_service.dart';

class LocationMap extends StatefulWidget {
  const LocationMap({super.key});

  @override
  LocationMapState createState() => LocationMapState();
}

class LocationMapState extends State<LocationMap> {
  LatLng _currentPosition =
      const LatLng(49.2273106, 16.5983539); // Default position (VUT FIT)
  final MapController _mapController = MapController();
  StreamSubscription<Position>? _positionStream;
  bool trackPosition = true;
  final _waterBubblerService = DI.get<WaterBubblerService>();
  final LocationService _locationService = LocationService();
  Timer? _debounceTimer;
  List<WaterBubbler> _waterBubblers = [];

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  @override
  void dispose() {
    _locationService.saveLastKnownPosition(_currentPosition);
    _positionStream?.cancel();
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    LatLng? lastKnownPosition = await _locationService.getLastKnownPosition();
    if (lastKnownPosition != null) {
      setState(() {
        _currentPosition = lastKnownPosition;
        _mapController.move(_currentPosition, 13.0);
      });
    }

    if (await _locationService.isLocationServiceEnabled()) {
      _startLocationUpdates();
    }
  }

  void _startLocationUpdates() {
    _positionStream =
        _locationService.getPositionStream().listen((Position position) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        if (trackPosition) {
          _mapController.move(_currentPosition, 15.0);
        }
      });
    });
  }

  void _onPositionChanged(MapCamera position, bool hasGesture) {
    trackPosition = false;

    _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final waterBubblers = await _waterBubblerService
          .getWaterBubblersByBBox(position.visibleBounds);
      setState(() {
        _waterBubblers = waterBubblers;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapWidget(
            initialPosition: _currentPosition,
            mapController: _mapController,
            onPositionChanged: _onPositionChanged,
            waterBubblers: _waterBubblers,
            currentPosition: _currentPosition,
            showPositionMarker: _positionStream != null,
          ),
          ControlButtons(
            mapController: _mapController,
            currentPosition: _currentPosition,
            onCenterButtonPressed: () {
              _mapController.moveAndRotate(_currentPosition, 15.0, 0.0);
              trackPosition = true;
            },
          ),
        ],
      ),
    );
  }
}
