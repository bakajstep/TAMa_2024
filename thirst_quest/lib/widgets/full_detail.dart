import 'package:flutter/material.dart';
import 'package:thirst_quest/states/bubbler_map_state.dart';
import 'package:provider/provider.dart';
import 'package:thirst_quest/utils/distance_convertor.dart';

class FullDetail extends StatelessWidget {
  final VoidCallback onClose;

  const FullDetail(
      {required this.onClose, super.key});

  @override
    Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final mapState = context.watch<BubblerMapState>();
    final selectedBubbler = mapState.selectedBubbler!;
    final currentLocation = mapState.currentPosition!;

    return Container(
      padding: EdgeInsets.all(16),
      height: screenHeight*0.7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '#',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedBubbler.name ?? 'Bubbler Details',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        distanceToDisplay(selectedBubbler.distanceTo(currentLocation)),
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      print("Settings");
                    },
                    child: Icon(Icons.settings, color: Colors.grey, size: 32),
                  ),
                  SizedBox(width: 24),
                  GestureDetector(
                    onTap: () {
                      print("Delete");
                    },
                    child: Icon(Icons.delete, color: Colors.red, size: 32),
                  ),
                  SizedBox(width: 24),
                  GestureDetector(
                    onTap: () {
                      print("Directions");
                    },
                    child: Icon(Icons.directions, color: Colors.green, size: 32),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            height: 150,
            width: screenWidth,
            color: Colors.grey[200],
            child: Center(
              child: Image.network(
                'https://via.placeholder.com/150',//selectedBubbler.photos[0].url, // TODO: add placeholder
                height: 200,
                fit: BoxFit.cover,
              ),
            )
          ),
          SizedBox(height: 16),
          Text(
            selectedBubbler.description ?? 'No description available.',
            style: TextStyle(fontSize: 16),
          ),
          TextButton(
            onPressed: () {},
            child: Text('Read more'),
          ),
        ],
      ),
    );
  }
}