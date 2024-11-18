import 'package:flutter/material.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';
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

  const NearestBubblers({required this.onClose, super.key});

  @override
  NearestBubblersState createState() => NearestBubblersState();
}

class NearestBubblersState extends State<NearestBubblers> {
  final WaterBubblerService bubblerService = DI.get<WaterBubblerService>();
  List<WaterBubbler> nearestBubblers = [];
  LatLng? positionOnLoad;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBubblers();
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
    final bubblerMapState =
        Provider.of<BubblerMapState>(context, listen: false);
    bubblerMapState.reloadBubblersOnMove = true;
    bubblerMapState.selectedBubbler = null;
    bubblerMapState.mapPixelOffset = 0.0;
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Container(
        height:
            MediaQuery.of(context).size.height * constants.bigInfoCardHeight,
        color: Colors.white,
        child: isLoading
            ? const Loading()
            : Column(
                children: [
                  GestureDetector(
                    onVerticalDragEnd: (details) {
                      if (details.primaryVelocity! > 0) {
                        _onClose(context);
                      }
                    },
                    child: Column(
                      children: [
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
                          padding: EdgeInsets.symmetric(
                              vertical: 7.5, horizontal: 10),
                          child: Text(
                            'Nearest Water Bubblers',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: nearestBubblers.length,
                      itemBuilder: (context, index) {
                        final waterBubbler = nearestBubblers[index];

                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: EdgeInsets.symmetric(
                              vertical: 7.5, horizontal: 10),
                          child: ListTile(
                            title: Text(waterBubbler.name ?? 'Water Bubbler'),
                            subtitle: Text(
                                'Distance: ~${distanceToDisplay(waterBubbler.distanceTo(positionOnLoad!))}'),
                            leading: waterBubbler.photos.isNotEmpty
                                ? Image.network(waterBubbler.photos[0].url)
                                : const Icon(Icons.local_drink),
                            trailing:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              NavigationButton(waterBubbler: waterBubbler),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons
                                      .favorite_border)) // TODO: Implement favorite functionality
                            ]),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
