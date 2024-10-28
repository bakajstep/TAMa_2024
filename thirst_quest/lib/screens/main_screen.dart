import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thirst_quest/controllers/location_controller.dart';
import 'package:thirst_quest/states/bubbler_map_state.dart';
import 'package:thirst_quest/widgets/location_map.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  final LocationController _locationController = LocationController();
  final BubblerMapState _bubblerMapState = BubblerMapState();

  @override
  void initState() {
    super.initState();
    _locationController.startLocationStreamIfAvailable(
        (position, isGpsLocation) =>
            _bubblerMapState.changeLocation(position, isGpsLocation, false));
  }

  @override
  void dispose() {
    _locationController.dispose();
    _bubblerMapState.dispose();
    super.dispose();
  }

  void _changePosition() {
    _bubblerMapState.changeLocationAndRotation(
        _locationController.currentPosition,
        _locationController.isLocationServiceEnabled,
        true,
        0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ChangeNotifierProvider(
      create: (context) => _bubblerMapState,
      child: Stack(
        children: [
          // This is the LocationMap that takes all available space
          Positioned.fill(
              child: LocationMap(
                  initialPosition: _locationController.currentPosition)),
          Positioned(
            top: 30,
            left: 16,
            right: 16,
            child: Center(
              child: SizedBox(
                height: 50,
                width: 300,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 20.0), // Add padding for text
                    suffixIcon: Icon(Icons.search), // Optional search icon
                  ),
                  onChanged: (value) {
                    // Handle search logic here
                  },
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              width: 56, // Match FloatingActionButton size
              height: 56,
              decoration: BoxDecoration(
                color: Colors.grey[700]?.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  // Action for the first button
                },
                icon: Icon(
                  Icons.account_circle,
                  size: 30,
                ),
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 90,
            left: 20,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.grey[700]?.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: _changePosition,
                icon: Icon(
                  Icons.navigation,
                  size: 30,
                ),
                color: Colors.white,
              ),
            ),
          ),

          Positioned(
            bottom: 160,
            left: 20,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.grey[700]?.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.white, size: 30),
                color: Colors.grey[800],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onSelected: (value) {
                  // Perform action based on selected option
                  if (value == 'Option 1') {
                    // Action for Option 1
                  } else if (value == 'Option 2') {
                    // Action for Option 2
                  } else if (value == 'Option 3') {
                    // Action for Option 3
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'Option 1',
                    child: Row(
                      children: [
                        Icon(Icons.settings, color: Colors.white),
                        SizedBox(width: 10),
                        Text('Option 1', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'Option 2',
                    child: Row(
                      children: [
                        Icon(Icons.info, color: Colors.white),
                        SizedBox(width: 10),
                        Text('Option 2', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'Option 3',
                    child: Row(
                      children: [
                        Icon(Icons.help, color: Colors.white),
                        SizedBox(width: 10),
                        Text('Option 3', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {
                    // Action for the centered button
                  },
                  icon: Icon(
                    Icons.surfing,
                    size: 60, // Adjust icon size as needed
                  ),
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
