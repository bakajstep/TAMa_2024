import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:thirst_quest/di.dart';
import 'package:thirst_quest/services/water_bubbler_service.dart';

class NearestBubblers extends StatelessWidget {
  final WaterBubblerService bubblerService = DI.get<WaterBubblerService>();

  NearestBubblers({super.key});

  @override
  Widget build(BuildContext context) {
    final waterBubblers = bubblerService
        .getXNearestBubblers(const LatLng(49.2273106, 16.5983539), 10, []);

    return ListView.builder(
      itemCount: waterBubblers.length,
      itemBuilder: (context, index) {
        final waterBubbler = waterBubblers[index];

        return ListTile(
          title: Text(waterBubbler.name ?? 'Water Bubbler'),
          subtitle: Text(waterBubbler.desc ?? 'No description'),
        );
      },
    );
  }
}
