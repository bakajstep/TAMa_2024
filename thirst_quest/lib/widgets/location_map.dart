import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';
import 'package:thirst_quest/di.dart';
import 'package:thirst_quest/services/water_bubbler_service.dart';
import 'package:thirst_quest/states/bubbler_map_state.dart';
import 'package:thirst_quest/widgets/map_widget.dart';

class LocationMap extends StatefulWidget {
  final LatLng initialPosition;

  const LocationMap({super.key, required this.initialPosition});

  @override
  LocationMapState createState() => LocationMapState();
}

class LocationMapState extends State<LocationMap> {
  final _waterBubblerService = DI.get<WaterBubblerService>();
  Timer? _debounceTimer;
  List<WaterBubbler> _waterBubblers = [];

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onPositionChanged(
      BubblerMapState state, MapCamera position, bool hasGesture) {
    state.trackPosition = false;

    _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final waterBubblers = await _waterBubblerService.getWaterBubblersByBBox(
          bounds: position.visibleBounds);
      setState(() {
        _waterBubblers = waterBubblers;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationMapState = context.watch<BubblerMapState>();

    return Scaffold(
      body: MapWidget(
        initialPosition: widget.initialPosition,
        currentPosition:
            locationMapState.currentPosition ?? widget.initialPosition,
        mapController: locationMapState.mapController,
        onPositionChanged: (mapCamera, hasGesture) =>
            _onPositionChanged(locationMapState, mapCamera, hasGesture),
        waterBubblers: _waterBubblers,
        showPositionMarker: locationMapState.showPositionMarker,
      ),
    );
  }
}
