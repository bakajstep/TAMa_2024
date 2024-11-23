import 'package:flutter/material.dart';
import 'package:thirst_quest/controllers/draggable_sheet_child_controller.dart';
import 'package:provider/provider.dart';
import 'package:thirst_quest/states/bubbler_map_state.dart';
import 'package:thirst_quest/assets/constants.dart' as constants;
import 'package:thirst_quest/utils/distance_convertor.dart';
import 'package:thirst_quest/widgets/navigation_button.dart';

class SmallDetailSheetChild extends StatefulWidget {
  final DraggableSheetChildController controller;
  //final ScrollController scrollController;

  const SmallDetailSheetChild({required this.controller, super.key});

  @override
  State<SmallDetailSheetChild> createState() => _SmallDetailSheetChildState(controller);
}

class _SmallDetailSheetChildState extends State<SmallDetailSheetChild> {
  final double _buttonsSize = 45.0;

  void _onHeightChanged() {
    
  }

  _SmallDetailSheetChildState(DraggableSheetChildController controller) {
    controller.onHeightChanged = _onHeightChanged;
    //controller.snapSizes = [0.0, constants.smallInfoCardHeight, constants.bigInfoCardHeight];
    //controller.initialSize = constants.smallInfoCardHeight;
  }

  @override
  Widget build(BuildContext context) {
    final bubblerMapState = context.watch<BubblerMapState>();
    final waterBubbler = bubblerMapState.selectedBubbler!;
    final currentLocation = bubblerMapState.currentPosition;
    final distanceBetweenBubblerAndCurrent = 
      currentLocation != null
      ? waterBubbler.distanceTo(currentLocation)
      : null;

    return 
              Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Container(
                          width: 50,
                          height: 5,
                          margin: EdgeInsets.only(top: 10, bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(2.5),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 0.0, horizontal: 15),
                          child: Row(
                            children: [
                              Icon(
                                Icons.circle,
                                size: _buttonsSize,

                                color: Colors.grey,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(waterBubbler.name ?? 'Water Bubbler',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        "Distance: ${distanceBetweenBubblerAndCurrent != null ? '~${distanceToDisplay(distanceBetweenBubblerAndCurrent)}' : "UNKNOWN"}",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal)),
                                  ],
                                ),
                              ),
                              NavigationButton(
                                waterBubbler: waterBubbler,
                                size: _buttonsSize,
                              ),
                            ].expand((x) => [const SizedBox(width: 10), x])
                              .skip(1)
                              .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ], // column children
              );
  }
}