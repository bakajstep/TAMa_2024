import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
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

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onPositionChanged(
      BubblerMapState state, MapCamera position, bool hasGesture) {
    final bubblerMapState =
        Provider.of<BubblerMapState>(context, listen: false);

    if (!bubblerMapState.reloadBubblersOnMove) {
      return;
    }

    state.trackPosition = false;

    _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final waterBubblers = await _waterBubblerService.getWaterBubblersByBBox(
          bounds: position.visibleBounds);
      bubblerMapState.waterBubblers = waterBubblers;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bubblerMapState = context.watch<BubblerMapState>();

    return Scaffold(
      body: MapWidget(
        initialPosition: widget.initialPosition,
        currentPosition:
            bubblerMapState.currentPosition ?? widget.initialPosition,
        mapController: bubblerMapState.mapController,
        onPositionChanged: (mapCamera, hasGesture) =>
            _onPositionChanged(bubblerMapState, mapCamera, hasGesture),
        waterBubblers: bubblerMapState.waterBubblers,
        showPositionMarker: bubblerMapState.showPositionMarker,
        selectedBubbler: bubblerMapState.selectedBubbler,
      ),
    );
  }
}