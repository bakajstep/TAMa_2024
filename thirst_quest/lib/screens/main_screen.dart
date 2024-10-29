import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thirst_quest/controllers/location_controller.dart';
import 'package:thirst_quest/states/bubbler_map_state.dart';
import 'package:thirst_quest/states/main_screen_action.dart';
import 'package:thirst_quest/widgets/location_map.dart';
import 'package:thirst_quest/widgets/map_controls.dart';
import 'package:thirst_quest/widgets/nearest_bubblers.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  final LocationController _locationController = LocationController();
  final BubblerMapState _bubblerMapState = BubblerMapState();
  MainScreenAction _mainScreenAction = MainScreenAction.none;
  final TextEditingController _searchController = TextEditingController();

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
    // _bubblerMapState.dispose();
    super.dispose();
  }

  void _centerToCurrentLocation() {
    _bubblerMapState.changeLocationAndRotation(
        _locationController.currentPosition,
        _locationController.isLocationServiceEnabled,
        true,
        0.0);
  }

  int _getMapFlex() {
    switch (_mainScreenAction) {
      case MainScreenAction.none:
        return 1;
      case MainScreenAction.smallDetail:
        return 7;
      case MainScreenAction.bigDetail:
      case MainScreenAction.nearestBubblers:
        return 3;
    }
  }

  int _getActionFlex() {
    switch (_mainScreenAction) {
      case MainScreenAction.none:
        return 0;
      case MainScreenAction.smallDetail:
        return 3;
      case MainScreenAction.bigDetail:
      case MainScreenAction.nearestBubblers:
        return 7;
    }
  }

  void _showNearestBubblers() {
    _bubblerMapState.changeLocation(_locationController.currentPosition,
        _locationController.isLocationServiceEnabled, false);
    setState(() {
      _mainScreenAction = MainScreenAction.nearestBubblers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ChangeNotifierProvider(
            create: (context) => _bubblerMapState,
            child: Column(children: [
              Flexible(
                flex: _getMapFlex(),
                child: Stack(
                  children: [
                    // This is the LocationMap that takes all available space
                    LocationMap(
                        initialPosition: _locationController.currentPosition),
                    if (_mainScreenAction == MainScreenAction.none ||
                        _mainScreenAction == MainScreenAction.smallDetail)
                      Positioned(
                        top: 30,
                        left: 20,
                        right: 20,
                        child: Padding(
                            padding:
                                const EdgeInsets.only(left: 48.0, right: 48.0),
                            child: Column(children: <Widget>[
                              const SizedBox(height: 16.0),
                              SearchBar(
                                controller: _searchController,
                                leading: IconButton(
                                    onPressed: () {
                                      // searchbar login here
                                    },
                                    icon: const Icon(Icons.search)),
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
                            ])),
                      ),
                    if (_mainScreenAction == MainScreenAction.none)
                      MapControls(
                          onCenterButtonPressed: _centerToCurrentLocation),
                    if (_mainScreenAction == MainScreenAction.none)
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
                              onPressed: _showNearestBubblers,
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
              ),
              Flexible(
                flex: _getActionFlex(),
                child: _mainScreenAction == MainScreenAction.nearestBubblers
                    ? NearestBubblers()
                    : Padding(padding: EdgeInsets.all(0)),
              )
            ])));
  }
}
