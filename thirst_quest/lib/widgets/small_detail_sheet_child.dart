import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:thirst_quest/assets/assign_color_to_bubbler_votes.dart';
import 'package:thirst_quest/controllers/draggable_sheet_child_controller.dart';
import 'package:provider/provider.dart';
import 'package:thirst_quest/states/bubbler_map_state.dart';
import 'package:thirst_quest/assets/constants.dart' as constants;
import 'package:thirst_quest/utils/distance_convertor.dart';
import 'package:thirst_quest/widgets/favorite_bubbler_button.dart';
import 'package:thirst_quest/widgets/navigation_button.dart';
import 'package:thirst_quest/widgets/maintain_bubbler_button.dart';

class SmallDetailSheetChild extends StatefulWidget {
  final DraggableSheetChildController controller;

  const SmallDetailSheetChild({required this.controller, super.key});

  @override
  State<SmallDetailSheetChild> createState() => _SmallDetailSheetChildState();

  static ScrollView build(DraggableSheetChildController controller, ScrollController scrollController) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              SmallDetailSheetChild(controller: controller),
            ],
          ),
        ),
      ],
    );
  }
}

class _SmallDetailSheetChildState extends State<SmallDetailSheetChild> {
  final double _buttonsSize = 30;

  void _onHeightChanged() {}

  @override
  void initState() {
    super.initState();
    widget.controller.onHeightChanged = _onHeightChanged;
    widget.controller.snapSizes = [0.0, constants.smallInfoCardHeight, constants.bigInfoCardHeight];
    widget.controller.initialSize = constants.smallInfoCardHeight;
  }

  @override
  Widget build(BuildContext context) {
    final bubblerMapState = context.watch<BubblerMapState>();
    final waterBubbler = bubblerMapState.selectedBubbler!;
    final currentLocation = bubblerMapState.currentPosition;
    final distanceBetweenBubblerAndCurrent = currentLocation != null ? waterBubbler.distanceTo(currentLocation) : null;

    return Column(
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
                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: _buttonsSize + 15,
                      color: assignColorToBubblerVotes(waterBubbler.upvoteCount, waterBubbler.downvoteCount),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(utf8.decode((waterBubbler.name ?? 'Water Bubbler').codeUnits),
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(
                              "Distance: ${distanceBetweenBubblerAndCurrent != null ? '~${distanceToDisplay(distanceBetweenBubblerAndCurrent)}' : "UNKNOWN"}",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
                        ],
                      ),
                    ),
                    NavigationButton(waterBubbler: waterBubbler, size: _buttonsSize),
                    FavoriteBubblerButton(
                        waterBubbler: waterBubbler,
                        size: _buttonsSize,
                        key: ValueKey(waterBubbler.id ?? waterBubbler.osmId)),
                    MaintainBubblerButton(waterBubbler: waterBubbler, size: _buttonsSize),
                  ].expand((x) => [const SizedBox(width: 5), x]).skip(1).toList(),
                ),
              ),
            ],
          ),
        ),
      ], // column children
    );
  }
}
