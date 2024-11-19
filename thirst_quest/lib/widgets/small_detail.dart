import 'package:flutter/material.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';
import 'package:thirst_quest/utils/distance_convertor.dart';
import 'package:thirst_quest/widgets/navigation_button.dart';

class SmallDetail extends StatelessWidget {
  final WaterBubbler waterBubbler;
  final double? distanceBetweenBubblerAndCurrent;
  final VoidCallback onClose;
  final VoidCallback onSwipeUp;

  final double _buttonsSize = 45.0;

  const SmallDetail({
    required this.waterBubbler,
    this.distanceBetweenBubblerAndCurrent,
    required this.onClose,
    required this.onSwipeUp,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * (1/7),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
      child: Column(
          children: [
            GestureDetector(
              onVerticalDragEnd: (details) {
                  if (details.primaryVelocity! > 0) {
                    onClose();
                  }
                  else if (details.primaryVelocity! < 0) {
                    onSwipeUp();
                  }
                },
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                    children: [
                      Container(
                        width: 50,
                        height: 5,
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(2.5),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 15),
                        child: Row(
                          children: [
                            Icon(Icons.circle, size: _buttonsSize, color: Colors.grey,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(waterBubbler.name ?? 'Water Bubbler', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                  Text("Distance: ${distanceBetweenBubblerAndCurrent != null ? '~${distanceToDisplay(distanceBetweenBubblerAndCurrent!)}' : "UNKNOWN"}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
                                ],
                              ),
                            ),
                            NavigationButton(waterBubbler: waterBubbler, size: _buttonsSize,),
                          ].expand((x) => [const SizedBox(width: 10), x]).skip(1).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              
            ),
          ],
        ),
    );
  }
}