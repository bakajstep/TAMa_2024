import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';

class MaintainBubblerButton extends StatelessWidget {
  final WaterBubbler waterBubbler;
  final double? size;

  const MaintainBubblerButton({required this.waterBubbler, this.size, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[400], // Background color
        shape: BoxShape.circle, // Makes the background circular
      ),
      child: IconButton(
        onPressed: () => MapsLauncher.launchCoordinates(
          waterBubbler.latitude,
          waterBubbler.longitude,
          waterBubbler.name,
        ),
        iconSize: size != null ? (size! - 20) : 24,
        icon: const Icon(Icons.settings_sharp, color: Colors.white),
      ),
    );
  }
}
