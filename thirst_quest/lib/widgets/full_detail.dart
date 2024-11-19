import 'package:flutter/material.dart';
import 'package:thirst_quest/states/bubbler_map_state.dart';
import 'package:provider/provider.dart';
import 'package:thirst_quest/utils/distance_convertor.dart';
import 'package:carousel_slider/carousel_slider.dart';


class FullDetail extends StatelessWidget {
  final VoidCallback onClose;

  const FullDetail({required this.onClose, super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final mapState = context.watch<BubblerMapState>();
    final selectedBubbler = mapState.selectedBubbler!;
    final currentLocation = mapState.currentPosition!;
    final List<Image> carouselItems = [
      Image.network('data:image/jpeg;base64,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'),
      Image.network('https://img.pikbest.com/origin/10/03/91/71DpIkbEsTkuJ.jpg!w700wp'),
      Image.network('https://offgridworld.com/wp-content/uploads/2019/02/Finding-water-in-the-wild-7.jpg.webp'),
    ];

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
        children: [
          GestureDetector(
            onVerticalDragEnd: (details) {
              if (details.primaryVelocity! > 0) {
                onClose();
              }
            },
            child: Column(
              children: [
                // Drag Handle
                Center(
                  child: Container(
                    width: 45,
                    height: 5,
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
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
                              distanceToDisplay(
                                selectedBubbler.distanceTo(currentLocation),
                              ),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.favorite_border),
                          iconSize: 35.0,
                          onPressed: () {},
                        ),
                        SizedBox(width: 10),
                        IconButton(
                          icon: Icon(Icons.directions),
                          iconSize: 35.0,
                          onPressed: () {},
                        ),
                        SizedBox(width: 10),
                        IconButton(
                          icon: Icon(Icons.settings),
                          iconSize: 35.0,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.thumb_up, color: Colors.green),
                              Text(
                                "1.2K",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Icon(Icons.thumb_down, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.verified, color: Colors.blue, size: 28),
                      SizedBox(width: 8),
                      Icon(Icons.wheelchair_pickup, color: Colors.blue, size: 28),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                CarouselSlider(
                  items: carouselItems,
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.2, // Customize the height of the carousel
                    autoPlay: false, // Enable auto-play
                    enlargeCenterPage: false, // Don't enlarge the center item
                    enableInfiniteScroll: true, // Enable infinite scroll
                    viewportFraction: 0.5, // Show next/previous items more prominently on the sides
                    onPageChanged: (index, reason) {
                      // Optional callback when the page changes
                      // You can use it to update any additional UI components
                    },
                  ),
                ),


                // Container(
                //   height: 150,
                //   width: screenWidth,
                //   color: Colors.grey[200],
                //   child: Center(
                //     child: Image.network(
                //       'https://via.placeholder.com/150', // TODO: Placeholder image
                //       height: 200,
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                // ),
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
          ),
        ],
      ),
    );
  }
}
