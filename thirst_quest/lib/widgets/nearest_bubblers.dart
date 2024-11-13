import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';

class NearestBubblers extends StatelessWidget {
  final List<WaterBubbler> nearestBubblers;
  final VoidCallback onClose;

  const NearestBubblers(
      {required this.nearestBubblers, required this.onClose, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity! > 0) {
              onClose();
            }
          },
          child: Container(
            width: 50,
            height: 5,
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 7.5, horizontal: 10),
          child: Text(
            'Nearest Water Bubblers',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
            child: ListView.builder(
          itemCount: nearestBubblers.length,
          itemBuilder: (context, index) {
            final waterBubbler = nearestBubblers[index];

            return Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.symmetric(vertical: 7.5, horizontal: 10),
              child: ListTile(
                title: Text(waterBubbler.name ?? 'Water Bubbler'),
                subtitle: Text(waterBubbler.desc ?? 'No description'),
                trailing: IconButton(
                    onPressed: () => MapsLauncher.launchCoordinates(
                        waterBubbler.latitude,
                        waterBubbler.longitude,
                        waterBubbler.name),
                    icon: const Icon(Icons.navigation)),
              ),
            );
          },
        ))
      ],
    );
  }
}
