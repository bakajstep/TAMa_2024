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
  final TextEditingController searchController = TextEditingController();

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
            left: 20,
            right: 20,
            child: Padding(
              padding: const EdgeInsets.only(left: 48.0, right: 48.0),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 16.0),
                  SearchBar(
                    controller: searchController,
                    leading: IconButton(
                      onPressed: () {
                        // searchbar login here
                      },
                      icon: const Icon(Icons.search)
                    ),
                    // trailing: [
                    //   IconButton(
                    //     onPressed: () {
                    //       // searchbar login here
                    //     },
                    //     icon: const Icon(Icons.mic)
                    //   )
                    // ],
                    hintText: 'Search...',
                  )
                ],
              ),
            ),
          ),

        Positioned(
          bottom: 20,
          left: 20,
          child: Container(
            width: 46, // Match FloatingActionButton size
            height: 46,
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
          bottom: 75,
          left: 20,
          child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.grey[700]?.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {
                // Action for the second button
              },
              icon: Icon(
                Icons.navigation,
                size: 30,
              ),
              color: Colors.white,
            ),
          ),
        ),

        Positioned(
          bottom: 130,
          left: 20,
          child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.grey[700]?.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: Colors.white, size: 30),
              color: Colors.grey[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onSelected: (value) {
                // Perform action based on selected option
                if (value == 'Filter map') {
                  // Action for Filter map
                } else if (value == 'New source') {
                  // Action for New source
                } else if (value == 'Option 3') {
                  // Action for Option 3
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'Filter map',
                  child: Row(
                    children: [
                      Icon(Icons.filter_alt, color: Colors.white),
                      SizedBox(width: 10),
                      Text('Filter map', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'New source',
                  child: Row(
                    children: [
                      Icon(Icons.water_drop, color: Colors.white),
                      SizedBox(width: 10),
                      Text('New source', style: TextStyle(color: Colors.white)),
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
