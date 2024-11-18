import 'package:flutter/material.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';

class BubblerSelected extends Notification {
  final WaterBubbler selectedWaterBubbler;

  BubblerSelected({required this.selectedWaterBubbler});
}