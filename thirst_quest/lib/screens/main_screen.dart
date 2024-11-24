import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';
import 'package:thirst_quest/controllers/draggable_sheet_child_controller.dart';
import 'package:thirst_quest/controllers/location_controller.dart';
import 'package:thirst_quest/di.dart';
import 'package:thirst_quest/notifications/bubbler_selected.dart';
import 'package:thirst_quest/notifications/draggable_sheet_changed_size.dart';
import 'package:thirst_quest/services/water_bubbler_service.dart';
import 'package:thirst_quest/states/bubbler_map_state.dart';
import 'package:thirst_quest/states/main_screen_action.dart';
import 'package:thirst_quest/utils/double_equals.dart';
import 'package:thirst_quest/widgets/draggable_sheet.dart';
import 'package:thirst_quest/widgets/full_detail_sheet_child.dart';
import 'package:thirst_quest/widgets/location_map.dart';
import 'package:thirst_quest/widgets/map_controls.dart';
import 'package:thirst_quest/assets/constants.dart' as constants;
import 'package:thirst_quest/widgets/nearest_bubblers.dart';
import 'package:thirst_quest/widgets/small_detail_sheet_child.dart';

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
  final TextEditingController _searchController = TextEditingController();
  final DraggableScrollableController _draggableController =
      DraggableScrollableController();

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

  bool _onDraggableSheetChangedSize(DraggableSheetChangedSize notification) {
    switch (_mainScreenAction) {
      case MainScreenAction.nearestBubblers:
        if (doubleEquals(notification.newSize, 0.0)) {
          _closeNearestBubblers();
        }
        break;

      case MainScreenAction.fullDetail:
        if (doubleEquals(notification.newSize, 0.0)) {
          _closeFullDetail();
        } else if (doubleEquals(
            notification.newSize, constants.smallInfoCardHeight)) {
          _showBubblerSmallDetail(_bubblerMapState.selectedBubbler!);
        }
        break;

      case MainScreenAction.smallDetail:
        if (doubleEquals(notification.newSize, 0.0)) {
          _closeBubblerSmallDetail();
        } else if (doubleEquals(
            notification.newSize, constants.bigInfoCardHeight)) {
          _showFullDetail();
        }
        break;

      default:
        break;
    }
    return true;
  }

  Widget _buildEmptyDraggableSheet(DraggableSheetChildController controller,
      ScrollController scrollController) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [],
    );
  }

  void _showNearestBubblers() async {
    setState(() {
      _mainScreenAction = MainScreenAction.nearestBubblers;
    });

    if (_draggableController.isAttached) {
      DraggableSheet.animateSheet(
          _draggableController, constants.bigInfoCardHeight);
    }
  }

  void _closeNearestBubblers() {
    setState(() {
      _mainScreenAction = MainScreenAction.none;
    });
  }

  void _showFullDetail() async {
    _bubblerMapState.reloadBubblersOnMove = false;
    _bubblerMapState.mapPixelOffset =
        -(MediaQuery.of(context).size.height * constants.bigInfoCardHeight / 2);
    _bubblerMapState.mapMove(_bubblerMapState.selectedBubbler!.position);

    setState(() {
      _mainScreenAction = MainScreenAction.fullDetail;
    });

    if (_draggableController.isAttached) {
      DraggableSheet.animateSheet(
          _draggableController, constants.bigInfoCardHeight);
    }
  }

  void _closeFullDetail() {
    _bubblerMapState.reloadBubblersOnMove = true;
    _bubblerMapState.mapPixelOffset = 0.0;
    _bubblerMapState.selectedBubbler = null;

    setState(() {
      _mainScreenAction = MainScreenAction.none;
    });
  }

  void _showBubblerSmallDetail(WaterBubbler selectedWaterBubbler) {
    _bubblerMapState.reloadBubblersOnMove = true;
    _bubblerMapState.mapPixelOffset = 0.0;
    _bubblerMapState.selectedBubbler = selectedWaterBubbler;

    setState(() {
      _mainScreenAction = MainScreenAction.smallDetail;
    });

    if (_draggableController.isAttached) {
      DraggableSheet.animateSheet(
          _draggableController, constants.smallInfoCardHeight);
    }
  }

  void _closeBubblerSmallDetail() {
    _bubblerMapState.selectedBubbler = null;
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
                    NotificationListener<BubblerSelected>(
                      onNotification: (notification) {
                        _showBubblerSmallDetail(
                            notification.selectedWaterBubbler);
                        return true;
                      },
                      child: LocationMap(
                          initialPosition: _locationController.currentPosition),
                    ),
                    Positioned(
                        top: 15,
                        left: 20,
                        right: 20,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: _mainScreenAction == MainScreenAction.none ||
                                  _mainScreenAction ==
                                      MainScreenAction.smallDetail
                              ? 1.0
                              : 0.0,
                          child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0),
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
                        )),
                    MapControls(
                      onCenterButtonPressed: _centerToCurrentLocation,
                      bottomOffset: _mainScreenAction == MainScreenAction.none
                          ? 0.0
                          : MediaQuery.of(context).size.height *
                              constants.smallInfoCardHeight,
                      visible: _mainScreenAction == MainScreenAction.none ||
                          _mainScreenAction == MainScreenAction.smallDetail,
                    ),
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: AnimatedOpacity(
                          duration: Duration(milliseconds: 300),
                          opacity: _mainScreenAction == MainScreenAction.none
                              ? 1.0
                              : 0.0,
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
                          )),
                    ),
                  ],
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: NotificationListener<DraggableSheetChangedSize>(
                      onNotification: _onDraggableSheetChangedSize,
                      child: DraggableSheet(
                        controller: _draggableController,
                        initialSize: switch (_mainScreenAction) {
                          MainScreenAction.nearestBubblers =>
                            constants.bigInfoCardHeight,
                          MainScreenAction.fullDetail =>
                            constants.bigInfoCardHeight,
                          MainScreenAction.smallDetail =>
                            constants.smallInfoCardHeight,
                          _ => 0.0,
                        },
                        snapSizes: switch (_mainScreenAction) {
                          MainScreenAction.nearestBubblers => [
                              0.0,
                              constants.bigInfoCardHeight
                            ],
                          MainScreenAction.fullDetail => [
                              0.0,
                              constants.smallInfoCardHeight,
                              constants.bigInfoCardHeight
                            ],
                          MainScreenAction.smallDetail => [
                              0.0,
                              constants.smallInfoCardHeight,
                              constants.bigInfoCardHeight
                            ],
                          _ => [0.0],
                        },
                        child: switch (_mainScreenAction) {
                          MainScreenAction.nearestBubblers =>
                            (controller, scrollController) =>
                                NearestBubblers.build(controller,
                                    scrollController, _closeNearestBubblers),
                          MainScreenAction.fullDetail =>
                            FullDetailSheetChild.build,
                          MainScreenAction.smallDetail =>
                            SmallDetailSheetChild.build,
                          _ => _buildEmptyDraggableSheet,
                        },
                      ),
                    ),
                  ))
            ])));
  }
}
