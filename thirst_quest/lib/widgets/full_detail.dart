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
    // final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final mapState = context.watch<BubblerMapState>();
    final selectedBubbler = mapState.selectedBubbler!;
    final currentLocation = mapState.currentPosition!;
    final List<Image> carouselItems = [
      Image.network('https://d34-a.sdn.cz/d_34/c_img_QK_3/IYU6je.mpo?fl=res,,500,1'),
      Image.network('https://d34-a.sdn.cz/d_34/c_img_G_p/oFQQ2j.jpeg?fl=res,,500,1'),
      Image.network('https://d34-a.sdn.cz/d_34/c_img_QM_x/mtXrCt.mpo?fl=res,,500,1'),
      Image.network('https://d34-a.sdn.cz/d_34/c_img_QJ_u/4mnrGE.mpo?fl=res,,500,1'),
    ];

    return Container(
      padding: EdgeInsets.all(16),
      height: screenHeight * 0.7,
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

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(Icons.thumb_up),
                                color: Colors.green,
                                iconSize: 35.0,
                                onPressed: () {},
                              ),
                              Text(
                                "1.2K",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: Icon(Icons.thumb_down),
                                color: Colors.red,
                                iconSize: 35.0,
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.verified, color: Colors.blue, size: 28),
                            SizedBox(width: 16),
                            // Icon(Icons.wheelchair_pickup, color: Colors.blue, size: 28),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                CarouselSlider(
                  items: carouselItems,
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.2, // Customize the height of the carousel
                    autoPlay: false, // Enable auto-play
                    enlargeCenterPage: false, // Don't enlarge the center item
                    enableInfiniteScroll: false, // Enable infinite scroll
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

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            selectedBubbler.description ?? 'No description available.',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      )),
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
