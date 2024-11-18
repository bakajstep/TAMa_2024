import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';

class NavigationButton extends StatelessWidget{
  final WaterBubbler waterBubbler;
  final double? size;

  const NavigationButton({required this.waterBubbler, this.size, super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => MapsLauncher.launchCoordinates(
            waterBubbler.latitude,
            waterBubbler.longitude,
            waterBubbler.name),
        padding: EdgeInsets.all(5),
        iconSize: size != null ? (size!-10) : null,
        icon: const Icon(Icons.navigation)
      );
  }
}