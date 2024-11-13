import 'package:flutter/material.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';

class NearestBubblers extends StatelessWidget {
  final List<WaterBubbler> nearestBubblers;

  NearestBubblers({required this.nearestBubblers, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: 7.5, horizontal: 10),
            child: Text(
              'Nearest Water Bubblers',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
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
              ),
            );
          },
        ))
      ],
    );
  }
}
