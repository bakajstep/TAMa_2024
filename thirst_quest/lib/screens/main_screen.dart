import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';
import 'package:thirst_quest/controllers/location_controller.dart';
import 'package:thirst_quest/di.dart';
import 'package:thirst_quest/services/water_bubbler_service.dart';
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
  final WaterBubblerService bubblerService = DI.get<WaterBubblerService>();
  MainScreenAction _mainScreenAction = MainScreenAction.none;
  List<WaterBubbler> _nearestBubblers = [];
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

  void _showNearestBubblers() async {
    _bubblerMapState.reloadBubblersOnMove = false;

    final currentPosition = _bubblerMapState.currentPosition!;
    final leftBottomCorner = LatLng(
        currentPosition.latitude - 0.02, currentPosition.longitude - 0.02);
    final rightTopCorner = LatLng(
        currentPosition.latitude + 0.02, currentPosition.longitude + 0.02);

    _nearestBubblers = await bubblerService.getXNearestBubblers(
        currentPosition, 10, LatLngBounds(leftBottomCorner, rightTopCorner));

    if (_nearestBubblers.isNotEmpty) {
      final waterBubbler = _nearestBubblers[0];
      _bubblerMapState.mapPixelOffset =
          mounted ? -(MediaQuery.of(context).size.height * 0.7 / 2) : 0.0;
      _bubblerMapState.mapMove(waterBubbler.position);
      _bubblerMapState.selectedBubbler = waterBubbler;
      _bubblerMapState.waterBubblers = _nearestBubblers;
    }

    setState(() {
      _mainScreenAction = MainScreenAction.nearestBubblers;
    });
  }

  void _closeNearestBubblers() {
    _bubblerMapState.reloadBubblersOnMove = true;
    _bubblerMapState.selectedBubbler = null;
    _bubblerMapState.mapPixelOffset = 0.0;
    setState(() {
      _mainScreenAction = MainScreenAction.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ChangeNotifierProvider(
            create: (context) => _bubblerMapState,
            child: Stack(children: [
              Positioned.fill(
                child: Stack(
                  children: [
                    // This is the LocationMap that takes all available space
                    LocationMap(
                        initialPosition: _locationController.currentPosition),
                    if (_mainScreenAction == MainScreenAction.none ||
                        _mainScreenAction == MainScreenAction.smallDetail)
                      Positioned(
                        top: 15,
                        left: 20,
                        right: 20,
                        child: Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
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
              Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 500),
                      transitionBuilder: (child, animation) {
                        final offsetAnimation = Tween<Offset>(
                          begin: Offset(0, 1),
                          end: Offset(0, 0),
                        ).animate(animation);
                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                      switchInCurve: Curves.easeInOut,
                      switchOutCurve: Curves.easeInOut,
                      child:
                          _mainScreenAction == MainScreenAction.nearestBubblers
                              ? NearestBubblers(
                                  nearestBubblers: _nearestBubblers,
                                  onClose: _closeNearestBubblers,
                                )
                              : null))
            ])));
  }
}
