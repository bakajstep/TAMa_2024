import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:thirst_quest/assets/thirst_quest_icons.dart';
import 'package:thirst_quest/screens/add_bubbler_detail.dart';
import 'package:thirst_quest/assets/constants.dart' as constants;

class AddBubblerMapScreen extends StatefulWidget {
  final LatLng location;

  const AddBubblerMapScreen({super.key, required this.location});

  @override
  State<AddBubblerMapScreen> createState() => _AddBubblerMapScreenState();
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
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              ),
            ],
          ),
          Center(
            child: Transform.translate(
              offset: Offset(0.0, -(constants.createBubblerIconSize/2)), // Offset to have the pin's tip at the center of the screen
              child: Icon(
                ThirstQuestIcons.bubblerReflection,
                color: Colors.indigoAccent,
                size: constants.createBubblerIconSize,
              ),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text("Continue"),
            ),
          ),
        ],
      ),
    );
  }
}

