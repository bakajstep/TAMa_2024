import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';
import 'package:thirst_quest/di.dart';
import 'package:thirst_quest/services/water_bubbler_service.dart';
import 'package:thirst_quest/states/bubbler_map_state.dart';
import 'package:thirst_quest/widgets/loading.dart';

class NearestBubblers extends StatelessWidget {
  final WaterBubblerService bubblerService = DI.get<WaterBubblerService>();

  NearestBubblers({super.key});

  @override
  Widget build(BuildContext context) {
    final locationMapState = context.watch<BubblerMapState>();
    final currentPosition = locationMapState.currentPosition!;
    final leftBottomCorner = LatLng(
        currentPosition.latitude - 0.02, currentPosition.longitude - 0.02);
    final rightTopCorner = LatLng(
        currentPosition.latitude + 0.02, currentPosition.longitude + 0.02);

    return FutureBuilder<List<WaterBubbler>>(
        future: bubblerService.getXNearestBubblers(currentPosition, 10,
            LatLngBounds(leftBottomCorner, rightTopCorner)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No water bubblers found.'));
          }

          final waterBubblers = snapshot.data!;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            locationMapState.changeLocation(
                waterBubblers[0].position, false, false);
          });

          return Expanded(
              child: Column(
            children: [
              Text('Nearest Water Bubblers'),
              ListView.builder(
                itemCount: waterBubblers.length,
                itemBuilder: (context, index) {
                  final waterBubbler = waterBubblers[index];

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 7.5, horizontal: 10),
                    child: ListTile(
                      title: Text(waterBubbler.name ?? 'Water Bubbler'),
                      subtitle: Text(waterBubbler.desc ?? 'No description'),
                    ),
                  );
                },
              )
            ],
          ));
        });
  }
}
