import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';
import 'package:thirst_quest/controllers/draggable_sheet_child_controller.dart';
import 'package:thirst_quest/assets/constants.dart' as constants;
import 'package:thirst_quest/states/bubbler_map_state.dart';
import 'package:provider/provider.dart';
import 'package:thirst_quest/utils/distance_convertor.dart';
import 'package:thirst_quest/assets/assign_color_to_bubbler_votes.dart';
import 'package:thirst_quest/widgets/favorite_bubbler_button.dart';
import 'package:thirst_quest/widgets/navigation_button.dart';
import 'package:thirst_quest/widgets/maintain_bubbler_button.dart';
import 'package:thirst_quest/widgets/like_dislike_button.dart';
import 'package:thirst_quest/widgets/image_gallery.dart';

class FullDetailSheetChild extends StatefulWidget {
  final DraggableSheetChildController controller;

  const FullDetailSheetChild({required this.controller, super.key});

  @override
  State<FullDetailSheetChild> createState() => _FullDetailSheetChildState();

  static ScrollView build(DraggableSheetChildController controller, ScrollController scrollController) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              FullDetailSheetChild(controller: controller),
            ],
          ),
        ),
      ],
    );
  }
}

class IconDataInfo {
  final IconData icon;
  final double size;
  final Color color;

  IconDataInfo({required this.icon, required this.size, required this.color});
}

class _FullDetailSheetChildState extends State<FullDetailSheetChild> {
  final double _buttonsSize = 45.0;
  
  void _onHeightChanged() {
    
  }

  @override
  void initState() {
    super.initState();
    widget.controller.onHeightChanged = _onHeightChanged;
    widget.controller.snapSizes = [0.0, constants.smallInfoCardHeight, constants.bigInfoCardHeight];
    widget.controller.initialSize = constants.bigInfoCardHeight;
  }

  @override
  Widget build(BuildContext context) {
    final mapState = context.watch<BubblerMapState>();
    final selectedBubbler = mapState.selectedBubbler!;
    final currentLocation = mapState.currentPosition!;
    final List<Image> carouselItems = [
      Image.network('https://d34-a.sdn.cz/d_34/c_img_QK_3/IYU6je.mpo?fl=res,,500,1'),
      Image.network('https://d34-a.sdn.cz/d_34/c_img_G_p/oFQQ2j.jpeg?fl=res,,500,1'),
      Image.network('https://d34-a.sdn.cz/d_34/c_img_QM_x/mtXrCt.mpo?fl=res,,500,1'),
      Image.network('https://d34-a.sdn.cz/d_34/c_img_QJ_u/4mnrGE.mpo?fl=res,,500,1'),
    ];
    final iconDataList = [
      IconDataInfo(icon: Icons.accessible, size: 30, color: Colors.blue),
      IconDataInfo(icon: Icons.paid, size: 35, color: Colors.orange),
      IconDataInfo(icon: Icons.schedule, size: 30, color: Colors.red),
      IconDataInfo(icon: Icons.not_accessible, size: 30, color: Colors.grey),
      IconDataInfo(icon: Icons.forest, size: 30, color: Colors.green),
      // IconDataInfo(icon: Icons.verified, size: 30, color: Colors.purple),
  ];

    return Column(
      children: [
        SizedBox(
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
                    // Icon(
                    //   Icons.circle,
                    //   size: _buttonsSize,
                    //   color: assignColorToBubblerVotes(selectedBubbler.upvoteCount,selectedBubbler.downvoteCount),
                    // ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              utf8.decode((selectedBubbler.name ?? 'Water Bubbler').codeUnits),
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Text(
                            "Distance: ${'~${distanceToDisplay(selectedBubbler.distanceTo(currentLocation),)}'}",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                    NavigationButton(waterBubbler: selectedBubbler, size: _buttonsSize),
                    FavoriteBubblerButton(waterBubbler: selectedBubbler, size: _buttonsSize),
                    MaintainbubblerButton(waterBubbler: selectedBubbler, size: _buttonsSize)
                  ].expand((x) => [const SizedBox(width: 10), x]).skip(1).toList(),
                ),
              ),
            ],
          ),
        ),








         Padding(
          padding: EdgeInsets.all(10.0), 
          // Draw a rectangle indication bubbler rating section
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              border: Border.all(color: Colors.grey[300]!, width: 1),
              borderRadius: BorderRadius.circular(24), 
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                // First row in Bubbler rating containing title
                Padding(
                  padding: EdgeInsets.all(2.0), 
                  child: SizedBox(
                    height: 18,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Bubbler rating",
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
                // Draw a line in Bubbler rating section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0), 
                  child: Container(
                    height: 1,
                    color: Colors.grey[400]!, 
                  ),
                ),
                // Second row in Bubbler rating section
                
                Row(
                  children: [
                    Flexible(
                      flex: 6,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LikeDislikeButton(waterBubbler: selectedBubbler),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 100,
                            width: 140,
                            child: GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10, 
                              ),
                              itemCount: iconDataList.length,
                              itemBuilder: (context, index) {
                                return Icon(
                                  iconDataList[index].icon,
                                  size: iconDataList[index].size,
                                  color: iconDataList[index].color,
                                );
                              },
                              physics: NeverScrollableScrollPhysics(), 
                              shrinkWrap: true, 
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.only(right: 10.0, left: 10.0), 
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
                  utf8.decode((selectedBubbler.description ?? 'No description available.').codeUnits),
                  style: TextStyle(fontSize: 16),
                ),
              ],
            )
          ),
        ),
        
        // TextButton(
        //   onPressed: () {},
        //   child: Text('Read more'),
        // ),

        ImageGallery(
            imageUrls: [
              'https://d34-a.sdn.cz/d_34/c_img_QK_3/IYU6je.mpo?fl=res,,500,1',
              'https://d34-a.sdn.cz/d_34/c_img_G_p/oFQQ2j.jpeg?fl=res,,500,1',
              'https://d34-a.sdn.cz/d_34/c_img_QM_x/mtXrCt.mpo?fl=res,,500,1',
              'https://d34-a.sdn.cz/d_34/c_img_QJ_u/4mnrGE.mpo?fl=res,,500,1',
              'https://d34-a.sdn.cz/d_34/c_img_QK_3/IYU6je.mpo?fl=res,,500,1',
              'https://d34-a.sdn.cz/d_34/c_img_G_p/oFQQ2j.jpeg?fl=res,,500,1',
              'https://d34-a.sdn.cz/d_34/c_img_QM_x/mtXrCt.mpo?fl=res,,500,1',
              'https://d34-a.sdn.cz/d_34/c_img_QJ_u/4mnrGE.mpo?fl=res,,500,1',
              'https://d34-a.sdn.cz/d_34/c_img_QK_3/IYU6je.mpo?fl=res,,500,1',
              'https://d34-a.sdn.cz/d_34/c_img_G_p/oFQQ2j.jpeg?fl=res,,500,1',
              'https://d34-a.sdn.cz/d_34/c_img_QM_x/mtXrCt.mpo?fl=res,,500,1',
              'https://d34-a.sdn.cz/d_34/c_img_QJ_u/4mnrGE.mpo?fl=res,,500,1',
            ],
          ),
      ],
    );
  }
}














      // Column(
      //   children: [
      //     // Drag Handle
      //     Center(
      //       child: Container(
      //         width: 50,
      //         height: 5,
      //         margin: EdgeInsets.only(top: 10, bottom: 10),
      //         decoration: BoxDecoration(
      //           color: Colors.grey,
      //           borderRadius: BorderRadius.circular(2.5),
      //         ),
      //       ),
      //     ),
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: [
      //         Row(
      //           children: [
      //             SizedBox(width: 8),
      //             Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Text(
      //                   selectedBubbler.name ?? 'Bubbler Details',
      //                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      //                 ),
      //                 SizedBox(height: 4),
      //                 Text(
      //                   distanceToDisplay(
      //                     selectedBubbler.distanceTo(currentLocation),
      //                   ),
      //                   style: TextStyle(
      //                     fontSize: 16,
      //                     color: Colors.grey[600],
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ],
      //         ),
      //         Row(
      //           children: [
      //             IconButton(
      //               icon: Icon(Icons.favorite_border),
      //               iconSize: 35.0,
      //               onPressed: () {},
      //             ),
      //             SizedBox(width: 10),
      //             IconButton(
      //               icon: Icon(Icons.directions),
      //               iconSize: 35.0,
      //               onPressed: () {},
      //             ),
      //             SizedBox(width: 10),
      //             IconButton(
      //               icon: Icon(Icons.settings),
      //               iconSize: 35.0,
      //               onPressed: () {},
      //             ),
      //           ],
      //         ),
      //       ],
      //     ),

      //     Padding(
      //       padding: EdgeInsets.symmetric(vertical: 12.0),
      //       child: Container(
      //         height: MediaQuery.of(context).size.height * 0.1,
      //         decoration: BoxDecoration(
      //           color: Colors.grey[300],
      //           borderRadius: BorderRadius.circular(20),
      //         ),
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             Expanded(
      //               child: Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                 children: [
      //                   IconButton(
      //                     icon: Icon(Icons.thumb_up),
      //                     color: Colors.green,
      //                     iconSize: 35.0,
      //                     onPressed: () {},
      //                   ),
      //                   Text(
      //                     "1.2K",
      //                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      //                   ),
      //                   IconButton(
      //                     icon: Icon(Icons.thumb_down),
      //                     color: Colors.red,
      //                     iconSize: 35.0,
      //                     onPressed: () {},
      //                   ),
      //                 ],
      //               ),
      //             ),
      //             Row(
      //               children: [
      //                 Icon(Icons.verified, color: Colors.blue, size: 28),
      //                 SizedBox(width: 16),
      //                 // Icon(Icons.wheelchair_pickup, color: Colors.blue, size: 28),
      //               ],
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),

      //     CarouselSlider(
      //       items: carouselItems,
      //       options: CarouselOptions(
      //         height: MediaQuery.of(context).size.height * 0.2, // Customize the height of the carousel
      //         autoPlay: false, // Enable auto-play
      //         enlargeCenterPage: false, // Don't enlarge the center item
      //         enableInfiniteScroll: false, // Enable infinite scroll
      //         viewportFraction: 0.5, // Show next/previous items more prominently on the sides
      //         onPageChanged: (index, reason) {
      //           // Optional callback when the page changes
      //           // You can use it to update any additional UI components
      //         },
      //       ),
      //     ),


      //     // Container(
      //     //   height: 150,
      //     //   width: screenWidth,
      //     //   color: Colors.grey[200],
      //     //   child: Center(
      //     //     child: Image.network(
      //     //       'https://via.placeholder.com/150', // TODO: Placeholder image
      //     //       height: 200,
      //     //       fit: BoxFit.cover,
      //     //     ),
      //     //   ),
      //     // ),

      //     Padding(
      //       padding: EdgeInsets.symmetric(vertical: 12.0),
      //       child: Container(
      //         height: MediaQuery.of(context).size.height * 0.1,
      //         decoration: BoxDecoration(
      //           color: Colors.grey[300],
      //           borderRadius: BorderRadius.circular(20),
      //         ),
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //           children: [
      //             Text(
      //               selectedBubbler.description ?? 'No description available.',
      //               style: TextStyle(fontSize: 16),
      //             ),
      //           ],
      //         )
      //       ),
      //     ),
      //     TextButton(
      //       onPressed: () {},
      //       child: Text('Read more'),
      //     ),
      //   ],
      // );
      //}
      //}