import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';
import 'package:thirst_quest/main.dart';
import 'package:thirst_quest/states/global_state.dart';
import 'package:thirst_quest/states/models/identity.dart';

class MaintainBubblerButton extends StatelessWidget {
  final WaterBubbler waterBubbler;
  final double? size;

  const MaintainBubblerButton({required this.waterBubbler, this.size, super.key});

  @override
  Widget build(BuildContext context) {
    final globalState = context.watch<GlobalState>();
    // final Identity? identity = globalState.user.identity;
    final String role = globalState.user.identity == null ? "" : globalState.user.identity!.roles[0];
    final String? bubblerOwnerId = waterBubbler.userId;
    final String? userId = role == "" ? null : globalState.user.identity!.id;

    final invisibleCondition = (role == "ROLE_ADMIN") || (userId == bubblerOwnerId);

    if (!invisibleCondition) return SizedBox.shrink();

    return Material(
      shape: const CircleBorder(),
      color: Colors.black.withOpacity(0.1),
      child: IconButton(
        onPressed: null,
        iconSize: size != null ? (size!) : null,
        padding: EdgeInsets.all(5),
        constraints: BoxConstraints(),
        style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
        icon: const Icon(Icons.settings_sharp, color: Colors.black),
      ),
    );

    // return Container(
    //   decoration: BoxDecoration(
    //     color: Colors.grey[400], // Background color
    //     shape: BoxShape.circle, // Makes the background circular
    //   ),
    //   child: IconButton(
    //     onPressed: () => MapsLauncher.launchCoordinates(
    //       waterBubbler.latitude,
    //       waterBubbler.longitude,
    //       waterBubbler.name,
    //     ),
    //     iconSize: size != null ? (size! - 20) : 24,
    //     icon: const Icon(Icons.settings_sharp, color: Colors.white),
    //   ),
    // );
  }
}
