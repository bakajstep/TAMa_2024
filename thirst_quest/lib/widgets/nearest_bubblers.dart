import 'package:flutter/material.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';
import 'package:thirst_quest/controllers/draggable_sheet_child_controller.dart';
import 'package:thirst_quest/notifications/bubbler_selected.dart';
import 'package:thirst_quest/widgets/navigation_button.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:thirst_quest/di.dart';
import 'package:thirst_quest/services/water_bubbler_service.dart';
import 'package:thirst_quest/states/bubbler_map_state.dart';
import 'package:thirst_quest/utils/distance_convertor.dart';
import 'package:thirst_quest/widgets/loading.dart';
import 'package:thirst_quest/assets/constants.dart' as constants;

class NearestBubblers extends StatefulWidget {
  final VoidCallback onClose;
  final DraggableSheetChildController controller;

  const NearestBubblers(
      {required this.onClose, required this.controller, super.key});

  @override
  NearestBubblersState createState() => NearestBubblersState();

  static ScrollView build(DraggableSheetChildController controller,
      ScrollController scrollController, VoidCallback onClose) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              NearestBubblers(controller: controller, onClose: onClose),
            ],
          ),
        ),
      ],
    );
  }
}

class NearestBubblersState extends State<NearestBubblers> {
  final WaterBubblerService bubblerService = DI.get<WaterBubblerService>();
  List<WaterBubbler> nearestBubblers = [];
  LatLng? positionOnLoad;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    widget.controller.onHeightChanged = () => _onClose(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBubblers();
    });
  }

  Future<void> _loadBubblers() async {
    final bubblerMapState =
        Provider.of<BubblerMapState>(context, listen: false);
    bubblerMapState.reloadBubblersOnMove = false;

    final currentPosition = positionOnLoad = bubblerMapState.currentPosition!;
    final delta = constants.nearestBubblersLatLonDelta;

    final leftBottomCorner = LatLng(
        currentPosition.latitude - delta, currentPosition.longitude - delta);
    final rightTopCorner = LatLng(
        currentPosition.latitude + delta, currentPosition.longitude + delta);

    final nearestBubblers = await bubblerService.getXNearestBubblers(
        currentPosition, 10, LatLngBounds(leftBottomCorner, rightTopCorner));

    if (nearestBubblers.isNotEmpty) {
      final waterBubbler = nearestBubblers[0];
      bubblerMapState.mapPixelOffset = mounted
          ? -(MediaQuery.of(context).size.height *
              constants.bigInfoCardHeight /
              2)
          : 0;
      bubblerMapState.mapMove(waterBubbler.position);

      bubblerMapState.selectedBubbler = waterBubbler;
      bubblerMapState.waterBubblers = nearestBubblers;
    }

    setState(() {
      this.nearestBubblers = nearestBubblers;
      isLoading = false;
    });
  }

  void _onClose(BuildContext context) {
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isLoading
          ? SizedBox(
              height: MediaQuery.of(context).size.height *
                  constants.bigInfoCardHeight,
              child: const Loading())
          : Column(children: [
              Container(
                width: 50,
                height: 5,
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 7.5, horizontal: 10),
                child: Text(
                  'Nearest Water Bubblers',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              ...nearestBubblers.map((waterBubbler) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 7.5, horizontal: 10),
                  child: ListTile(
                    onTap: () => BubblerSelected(
                            selectedWaterBubbler: waterBubbler,
                            showFullDetail: true)
                        .dispatch(context),
                    title: Text(waterBubbler.name ?? 'Water Bubbler'),
                    subtitle: Text(
                        'Distance: ~${distanceToDisplay(waterBubbler.distanceTo(positionOnLoad!))}'),
                    leading: waterBubbler.photos.isNotEmpty
                        ? Image.network(waterBubbler.photos[0].url)
                        : const Icon(Icons.local_drink),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      NavigationButton(waterBubbler: waterBubbler),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons
                              .favorite_border)) // TODO: Implement favorite functionality
                    ]),
                  ),
                );
              }),
            ]),
    );
  }
}
