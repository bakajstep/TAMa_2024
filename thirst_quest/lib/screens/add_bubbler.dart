import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:thirst_quest/assets/thirst_quest_icons.dart';
import 'package:thirst_quest/screens/add_bubbler_detail.dart';

class AddBubblerMapScreen extends StatefulWidget {
  final LatLng location;

  const AddBubblerMapScreen({super.key, required this.location});

  @override
  _AddBubblerMapScreenState createState() => _AddBubblerMapScreenState();
}

class _AddBubblerMapScreenState extends State<AddBubblerMapScreen> {
  late final MapController _mapController;
  late LatLng _selectedLocation;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _selectedLocation = widget.location;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Choose Bubbler location")),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selectedLocation,
              initialZoom: 17.0,
              onMapEvent: (mapEvent) {
                if (mapEvent is MapEventMove) {
                  setState(() {
                    _selectedLocation = mapEvent.camera.center;
                  });
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
            ],
          ),
          Center(
            child: Icon(
              ThirstQuestIcons.bubblerReflection,
              color: Colors.indigoAccent,
              size: 50.0,
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddBubblerDetailsScreen(
                      location: _selectedLocation,
                    ),
                  ),
                );
              },
              child: Text("Continue"),
            ),
          ),
        ],
      ),
    );
  }
}

