import 'package:flutter/material.dart';
import 'package:thirst_quest/assets/ThirstQuestIcons_icons.dart';
import 'package:thirst_quest/assets/constants.dart' as constants;
import 'package:thirst_quest/notifications/bubbler_selected.dart';



class WaterBubblerIcon extends StatefulWidget {
  final bool isCurrent;

  const WaterBubblerIcon({required this.isCurrent, super.key});

  @override
  WaterBubblerIconState createState() => WaterBubblerIconState();
}

class WaterBubblerIconState extends State<WaterBubblerIcon> {

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        BubblerSelected(val: true).dispatch(context);
      },
      alignment: Alignment.center,
      padding: EdgeInsets.zero,
      iconSize: constants.markerSize,
      icon: Icon(
        ThirstQuestIcons.bubbler_reflection,
        color: widget.isCurrent ? Colors.cyanAccent : Colors.indigoAccent
      ),
    );
  }
}
