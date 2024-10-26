import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationMap extends StatefulWidget {
  const LocationMap({super.key});

  @override
  LocationMapState createState() => LocationMapState();
}

class LocationMapState extends State<LocationMap> {
  LatLng _currentPosition = const LatLng(49.2273106, 16.5983539); // VUT FIT
  final MapController _mapController = MapController();
  StreamSubscription<Position>? _positionStream;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, don't continue
      return;
    }

    // Get the current location
    _startLocationUpdates();
  }

  void _startLocationUpdates() {
    _positionStream = Geolocator.getPositionStream(
            locationSettings: LocationSettings(
                distanceFilter: 2)) // Update the location every 2 meters
        .listen((Position position) => setState(() {
              _currentPosition = LatLng(position.latitude, position.longitude);
              _mapController.move(_currentPosition,
                  15.0); // Move the map to the current position
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentPosition,
              initialZoom: 15,
            ),
            children: [
              TileLayer(
                tileProvider: NetworkTileProvider(),
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: [
                  // Show the marker only if the location is available
                  if (_positionStream != null)
                    Marker(
                      width: 50.0,
                      height: 50.0,
                      point: _currentPosition,
                      child: Icon(
                        Icons.my_location,
                        color: Theme.of(context).colorScheme.primary,
                        size: 40.0,
                      ),
                    ),
                ],
              ),
              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                    onTap: () => launchUrl(
                        Uri.parse('https://openstreetmap.org/copyright')),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
              top: 16.0,
              right: 16.0,
              child: Column(
                children: [
                  IconButton(
                    iconSize: 25.0,
                    color: Colors.black,
                    onPressed: () => _mapController.rotate(0.0),
                    icon: const Icon(Icons.north),
                  ),
                  IconButton(
                    iconSize: 25.0,
                    color: Colors.black,
                    onPressed: () => _mapController.moveAndRotate(
                        _currentPosition, 15.0, 0.0),
                    icon: const Icon(Icons.my_location),
                  )
                ],
              )),
        ],
      ),
    );
  }
}
