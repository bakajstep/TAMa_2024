import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';
import 'package:url_launcher/url_launcher.dart';

class MapWidget extends StatelessWidget {
  final LatLng initialPosition;
  final MapController mapController;
  final Function(MapCamera, bool) onPositionChanged;
  final List<WaterBubbler> waterBubblers;
  final LatLng currentPosition;
  final bool showPositionMarker;
  final WaterBubbler? selectedBubbler;

  const MapWidget({
    super.key,
    required this.initialPosition,
    required this.mapController,
    required this.onPositionChanged,
    required this.waterBubblers,
    required this.currentPosition,
    required this.showPositionMarker,
    required this.selectedBubbler,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: initialPosition,
        initialZoom: 15,
        onPositionChanged: onPositionChanged,
      ),
      children: [
        TileLayer(
          tileProvider: NetworkTileProvider(),
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(
          markers: [
            if (showPositionMarker)
              Marker(
                width: 50.0,
                height: 50.0,
                point: currentPosition,
                child: Icon(
                  Icons.my_location,
                  color: Theme.of(context).colorScheme.primary,
                  size: 40.0,
                ),
              ),
            for (final waterBubbler in waterBubblers)
              Marker(
                width: 50.0,
                height: 50.0,
                point: LatLng(waterBubbler.latitude, waterBubbler.longitude),
                child: Icon(
                  Icons.local_drink,
                  color: waterBubbler == selectedBubbler
                      ? Colors.red
                      : Colors.blue,
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
                Uri.parse('https://openstreetmap.org/copyright'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
