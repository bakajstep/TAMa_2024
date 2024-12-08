import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';

class NavigationButton extends StatelessWidget {
  final WaterBubbler waterBubbler;
  final double? size;

  const NavigationButton({required this.waterBubbler, this.size, super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      color: Colors.black.withOpacity(0.1),
      child: IconButton(
        onPressed: () =>
            MapsLauncher.launchCoordinates(waterBubbler.latitude, waterBubbler.longitude, waterBubbler.name),
        iconSize: size != null ? (size!) : null,
        padding: EdgeInsets.all(5),
        constraints: BoxConstraints(),
        style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
        icon: const Icon(Icons.navigation, color: Colors.black),
      ),
    );
  }
}
