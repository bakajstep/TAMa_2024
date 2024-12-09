import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';
import 'package:thirst_quest/di.dart';
import 'package:thirst_quest/notifications/bubblers_reload.dart';
import 'package:thirst_quest/services/water_bubbler_service.dart';
import 'package:thirst_quest/states/global_state.dart';

class MaintainBubblerButton extends StatelessWidget {
  final WaterBubbler waterBubbler;
  final double? size;

  const MaintainBubblerButton({required this.waterBubbler, this.size, super.key});

  @override
  Widget build(BuildContext context) {
    final globalState = context.watch<GlobalState>();
    final WaterBubblerService bubblerService = DI.get<WaterBubblerService>();

    void deleteBubbler(String bubblerId) async {
      await bubblerService.deleteWaterBubbler(bubblerId);
      if (context.mounted) {
        BubblersReload().dispatch(context);
      }
  }

    final String role = globalState.user.identity == null ? "" : globalState.user.identity!.roles[0];
    final String? bubblerOwnerId = waterBubbler.userId;
    final String? userId = role == "" ? null : globalState.user.identity!.id;
    final invisibleCondition = (role == "ROLE_ADMIN") || (userId == bubblerOwnerId);

    if (!invisibleCondition) return SizedBox.shrink();

    return Material(
      shape: const CircleBorder(),
      color: Colors.black.withOpacity(0.1),
      child: PopupMenuButton<int>(
        icon: const Icon(Icons.settings_sharp, color: Colors.black),
        iconSize: 24.0, 
        padding: const EdgeInsets.all(5),
        constraints: const BoxConstraints(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onSelected: (int value) {
          if (value == 1) {
            // TODO: Redirect to bubbbler edit page
          } else if (value == 2) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirm Delete'),
                  content: const Text('Are you sure you want to delete this bubbler?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        deleteBubbler(waterBubbler.id!);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                );
              },
            );
          }
        },
        itemBuilder: (BuildContext context) => [
          PopupMenuItem<int>(
            value: 1,
            child: Row(
              children: const [
                Icon(Icons.edit, color: Colors.black),
                SizedBox(width: 8),
                Text('Edit'),
              ],
            ),
          ),
          PopupMenuItem<int>(
            value: 2,
            child: Row(
              children: const [
                Icon(Icons.delete, color: Colors.black),
                SizedBox(width: 8),
                Text('Delete'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
