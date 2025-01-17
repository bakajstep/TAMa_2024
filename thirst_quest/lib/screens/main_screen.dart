import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';
import 'package:thirst_quest/assets/thirst_quest_icons.dart';
import 'package:thirst_quest/controllers/bubblers_controller.dart';
import 'package:thirst_quest/controllers/draggable_sheet_child_controller.dart';
import 'package:thirst_quest/controllers/location_controller.dart';
import 'package:thirst_quest/controllers/main_action_controller.dart';
import 'package:thirst_quest/notifications/bubbler_selected.dart';
import 'package:thirst_quest/notifications/bubblers_reload.dart';
import 'package:thirst_quest/notifications/draggable_sheet_changed_size.dart';
import 'package:thirst_quest/states/bubbler_map_state.dart';
import 'package:thirst_quest/states/global_state.dart';
import 'package:thirst_quest/states/main_screen_action.dart';
import 'package:thirst_quest/utils/double_compare.dart';
import 'package:thirst_quest/utils/route_observer_provider.dart';
import 'package:thirst_quest/widgets/city_search_widget.dart';
import 'package:thirst_quest/widgets/draggable_sheet.dart';
import 'package:thirst_quest/widgets/full_detail.dart';
import 'package:thirst_quest/widgets/location_map.dart';
import 'package:thirst_quest/widgets/map_controls.dart';
import 'package:thirst_quest/assets/constants.dart' as constants;
import 'package:thirst_quest/widgets/nearest_bubblers.dart';
import 'package:thirst_quest/widgets/small_detail.dart';

class MainScreen extends StatefulWidget {
  final LatLng? initialPosition;

  const MainScreen({this.initialPosition, super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> with RouteAware {
  final LocationController _locationController = LocationController();
  final BubblerMapState _bubblerMapState = BubblerMapState();
  final MainActionController _mainActionController = MainActionController();
  final DraggableScrollableController _draggableController = DraggableScrollableController();
  final BubblersController _bubblersController = BubblersController();

  @override
  void initState() {
    super.initState();
    if (widget.initialPosition != null) {
      _locationController.initialLocation = widget.initialPosition!;
      _bubblerMapState.trackPosition = false;
    }

    _locationController.startLocationStreamIfAvailable(
        (position, isGpsLocation) => _bubblerMapState.changeLocation(position, isGpsLocation, false));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context)!;
    if (route is MaterialPageRoute) {
      RouteObserverProvider.of(context).routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    RouteObserverProvider.of(context).routeObserver.unsubscribe(this);
    _locationController.dispose();
    // _bubblerMapState.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    final state = Provider.of<GlobalState>(context, listen: false);

    _bubblerMapState.reloadBubblersOnMove = true;
    _bubblerMapState.filterFavorites = _bubblerMapState.filterFavorites && state.user.isLoggedIn;
    _bubblerMapState.mapPixelOffset = 0.0;
    _bubblerMapState.selectedBubbler = null;
    _bubblerMapState.waterBubblers = [];
    _mainActionController.pushAction(MainScreenAction.none);
    _draggableController.animateTo(0.0, duration: const Duration(microseconds: 1), curve: Curves.easeInOut);
    _bubblersController.refreshBubblers();
  }

  void _centerToCurrentLocation() {
    _bubblerMapState.changeLocationAndRotation(
        _locationController.currentPosition, _locationController.isLocationServiceEnabled, true, 0.0);
  }

  bool _onDraggableSheetChangedSize(DraggableSheetChangedSize notification) {
    switch (_mainActionController.currentAction) {
      case MainScreenAction.nearestBubblers:
        if (doubleEquals(notification.newSize, 0.0)) {
          _closeNearestBubblers();
        }
        break;

      case MainScreenAction.fullDetail:
        if (doubleEquals(notification.newSize, 0.0)) {
          _closeFullDetail();
        } else if (doubleEquals(notification.newSize, constants.smallInfoCardHeight)) {
          _showBubblerSmallDetail(_bubblerMapState.selectedBubbler!);
        }
        break;

      case MainScreenAction.smallDetail:
        if (doubleEquals(notification.newSize, 0.0)) {
          _closeBubblerSmallDetail();
        } else if (doubleEquals(notification.newSize, constants.bigInfoCardHeight)) {
          _showFullDetail();
        }
        break;

      default:
        break;
    }
    return true;
  }

  Widget _buildEmptyDraggableSheet(DraggableSheetChildController controller, ScrollController scrollController) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [],
    );
  }

  void _showNearestBubblers() async {
    setState(() {
      _mainActionController.pushAction(MainScreenAction.nearestBubblers);
    });

    if (_draggableController.isAttached) {
      DraggableSheet.animateSheet(_draggableController, constants.bigInfoCardHeight);
    }
  }

  void _closeNearestBubblers() {
    _bubblerMapState.reloadBubblersOnMove = true;
    _bubblerMapState.selectedBubbler = null;
    _bubblerMapState.mapPixelOffset = 0.0;
    setState(() {
      _mainActionController.pushAction(MainScreenAction.none);
    });
  }

  void _showFullDetail({WaterBubbler? selectedBubbler}) async {
    if (selectedBubbler != null) {
      _bubblerMapState.selectedBubbler = selectedBubbler;
    }

    _bubblerMapState.reloadBubblersOnMove = false;
    _bubblerMapState.mapPixelOffset = -(MediaQuery.of(context).size.height * constants.bigInfoCardHeight / 2);
    _bubblerMapState.mapMove(_bubblerMapState.selectedBubbler!.position);

    setState(() {
      _mainActionController.pushAction(MainScreenAction.fullDetail);
    });

    if (_draggableController.isAttached) {
      DraggableSheet.animateSheet(_draggableController, constants.bigInfoCardHeight);
    }
  }

  void _closeFullDetail() {
    _bubblerMapState.reloadBubblersOnMove = true;
    _bubblerMapState.mapPixelOffset = 0.0;
    _bubblerMapState.selectedBubbler = null;

    setState(() {
      _mainActionController.pushAction(MainScreenAction.none);
    });
  }

  void _showBubblerSmallDetail(WaterBubbler selectedWaterBubbler) {
    _bubblerMapState.reloadBubblersOnMove = true;
    _bubblerMapState.mapPixelOffset = 0.0;
    _bubblerMapState.selectedBubbler = selectedWaterBubbler;

    setState(() {
      _mainActionController.pushAction(MainScreenAction.smallDetail);
    });

    if (_draggableController.isAttached) {
      DraggableSheet.animateSheet(_draggableController, constants.smallInfoCardHeight);
    }
  }

  void _closeBubblerSmallDetail() {
    _bubblerMapState.selectedBubbler = null;
    setState(() {
      _mainActionController.pushAction(MainScreenAction.none);
    });
  }

  void _onPopInvokedWithResult(bool didPop, dynamic result) {
    if (didPop) {
      return;
    }

    final lastAction = _mainActionController.currentAction;
    _mainActionController.popAction();
    final newAction = _mainActionController.currentAction;

    if (newAction == MainScreenAction.none) {
      DraggableSheet.animateSheet(_draggableController, 0.0);
      if (lastAction == MainScreenAction.nearestBubblers) {
        _closeNearestBubblers();
        return;
      }
      if (lastAction == MainScreenAction.fullDetail) {
        _closeFullDetail();
        return;
      }
      if (lastAction == MainScreenAction.smallDetail) {
        _closeBubblerSmallDetail();
        return;
      }
    }

    if (_mainActionController.currentAction == MainScreenAction.smallDetail) {
      _showBubblerSmallDetail(_bubblerMapState.selectedBubbler!);
      return;
    }

    if (_mainActionController.currentAction == MainScreenAction.fullDetail) {
      _showFullDetail();
    }

    if (_mainActionController.currentAction == MainScreenAction.nearestBubblers) {
      _showNearestBubblers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: _mainActionController.currentAction == MainScreenAction.none,
        onPopInvokedWithResult: _onPopInvokedWithResult,
        child: ChangeNotifierProvider(
          create: (context) => _bubblerMapState,
          child: NotificationListener<BubblerSelected>(
            onNotification: (notification) {
              if (notification.showFullDetail) {
                _showFullDetail(selectedBubbler: notification.selectedWaterBubbler);
              }
              else {
                _mainActionController.pushAction(MainScreenAction.none);
                _showBubblerSmallDetail(notification.selectedWaterBubbler);
              }
              return true;
            },
            child: NotificationListener<BubblersReload>(
              onNotification: (notification) {
                didPopNext();
                return true;
              },
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Stack(
                      children: [
                        LocationMap(
                            initialPosition: _locationController.currentPosition,
                            bubblersController: _bubblersController),
                        Positioned(
                            top: 30,
                            left: 20,
                            right: 20,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: constants.shortAnimationDuration),
                              opacity: _mainActionController.currentAction == MainScreenAction.none ||
                                      _mainActionController.currentAction == MainScreenAction.smallDetail
                                  ? 1.0
                                  : 0.0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                child:
                                    CitySearchWidget(onCitySelected: (city) => _bubblerMapState.mapMove(city.position)),
                              ),
                            )),
                        MapControls(
                          onCenterButtonPressed: _centerToCurrentLocation,
                          bottomOffset: _mainActionController.currentAction == MainScreenAction.none
                              ? 0.0
                              : MediaQuery.of(context).size.height * constants.smallInfoCardHeight,
                          visible: _mainActionController.currentAction == MainScreenAction.none ||
                              _mainActionController.currentAction == MainScreenAction.smallDetail,
                        ),
                        Positioned(
                          bottom: 20,
                          left: 0,
                          right: 0,
                          child: AnimatedOpacity(
                              duration: Duration(milliseconds: constants.shortAnimationDuration),
                              opacity: _mainActionController.currentAction == MainScreenAction.none ? 1.0 : 0.0,
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
                                      ThirstQuestIcons.nearestV2SquaredSize,
                                      size: 70, // Adjust icon size as needed
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
                            initialSize: switch (_mainActionController.currentAction) {
                              MainScreenAction.nearestBubblers => constants.bigInfoCardHeight,
                              MainScreenAction.fullDetail => constants.bigInfoCardHeight,
                              MainScreenAction.smallDetail => constants.smallInfoCardHeight,
                              _ => 0.0,
                            },
                            snapSizes: switch (_mainActionController.currentAction) {
                              MainScreenAction.nearestBubblers => [0.0, constants.bigInfoCardHeight],
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
                            child: switch (_mainActionController.currentAction) {
                              MainScreenAction.nearestBubblers => (controller, scrollController) =>
                                  NearestBubblers.build(controller, scrollController, _closeNearestBubblers),
                              MainScreenAction.fullDetail => FullDetail.build,
                              MainScreenAction.smallDetail => SmallDetail.build,
                              _ => _buildEmptyDraggableSheet,
                            },
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
