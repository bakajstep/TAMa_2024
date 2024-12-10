import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';
import 'package:thirst_quest/assets/constants.dart' as constants;
import 'package:thirst_quest/widgets/water_bubbler_icon.dart';
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

  List<Marker> _buildMapMarkers() {
    List<WaterBubbler> bubblers = waterBubblers;
    if (selectedBubbler != null && !waterBubblers.contains(selectedBubbler)) {
      bubblers.add(selectedBubbler!);
    }

    return [
      for (final waterBubbler in bubblers)
        Marker(
          width: constants.markerSize + (constants.markerPadding * 2),
          height: constants.markerSize + (constants.markerPadding * 2),
          key: ValueKey(waterBubbler.id ?? waterBubbler.osmId),
          point: LatLng(waterBubbler.latitude, waterBubbler.longitude),
          alignment: Alignment.topCenter,
          rotate: true,
          child: Transform.translate(
            offset: Offset(0.0, constants.markerPadding),
            child: WaterBubblerIcon(
              isCurrent: selectedBubbler == waterBubbler,
              waterBubbler: waterBubbler,
            ),
          ),
        ),
    ];
  }

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
          userAgentPackageName: 'com.src.app',
        ),
        MarkerLayer(markers: [
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
        ]),
        MarkerClusterLayerWidget(
          options: MarkerClusterLayerOptions(
            maxClusterRadius: 45,
            size: const Size(40, 40),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(50),
            maxZoom: 17.0,
            rotate: true,
            polygonOptions: PolygonOptions(
                borderColor: Colors.blue.shade700.withOpacity(0.35),
                color: Colors.blue.shade700.withOpacity(0.35),
                borderStrokeWidth: 3),
            showPolygon: false,
            markers: _buildMapMarkers(),
            builder: (context, markers) {
              return Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.blue),
                child: Center(
                  child: Text(
                    markers.length.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
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
