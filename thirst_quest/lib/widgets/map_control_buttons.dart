import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ControlButtons extends StatelessWidget {
  final MapController mapController;
  final LatLng currentPosition;
  final VoidCallback onCenterButtonPressed;

  const ControlButtons({
    super.key,
    required this.mapController,
    required this.currentPosition,
    required this.onCenterButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16.0,
      right: 16.0,
      child: Column(
        children: [
          IconButton(
            iconSize: 25.0,
            color: Colors.black,
            onPressed: () => mapController.rotate(0.0),
            icon: const Icon(Icons.explore_outlined),
          ),
          IconButton(
            iconSize: 25.0,
            color: Colors.black,
            onPressed: onCenterButtonPressed,
            icon: const Icon(Icons.my_location),
          ),
        ],
      ),
    );
  }
}
