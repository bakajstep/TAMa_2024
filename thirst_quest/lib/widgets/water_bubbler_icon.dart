import 'package:flutter/material.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';
import 'package:thirst_quest/assets/thirst_quest_icons.dart';
import 'package:thirst_quest/assets/constants.dart' as constants;
import 'package:thirst_quest/notifications/bubbler_selected.dart';

class WaterBubblerIcon extends StatefulWidget {
  final bool isCurrent;
  final WaterBubbler waterBubbler;

  const WaterBubblerIcon({required this.isCurrent, required this.waterBubbler, super.key});

  @override
  WaterBubblerIconState createState() => WaterBubblerIconState();
}

class WaterBubblerIconState extends State<WaterBubblerIcon> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        BubblerSelected(selectedWaterBubbler: widget.waterBubbler).dispatch(context);
      },
      alignment: Alignment.center,
      padding: EdgeInsets.zero,
      iconSize: constants.markerSize,
      icon: Icon(ThirstQuestIcons.bubblerReflection, color: widget.isCurrent ? Colors.cyanAccent : Colors.indigoAccent),
    );
  }
}
