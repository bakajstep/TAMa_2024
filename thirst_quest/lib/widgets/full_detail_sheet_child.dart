import 'dart:convert';
import 'package:flutter/material.dart';
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
  final double _buttonsSize = 30.0;

  void _onHeightChanged() {}

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
    // final iconDataList = [
    //   IconDataInfo(icon: Icons.accessible, size: 30, color: Colors.blue),
    //   IconDataInfo(icon: Icons.paid, size: 35, color: Colors.orange),
    //   IconDataInfo(icon: Icons.schedule, size: 30, color: Colors.red),
    //   // IconDataInfo(icon: Icons.not_accessible, size: 30, color: Colors.grey),
    //   IconDataInfo(icon: Icons.forest, size: 30, color: Colors.green),
    //   IconDataInfo(icon: Icons.verified, size: 30, color: Colors.purple),
    // ];
    final List<String> images = selectedBubbler.photos.map((photo) => photo.url).toList();

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
                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: _buttonsSize + 15,
                      color: assignColorToBubblerVotes(selectedBubbler.upvoteCount, selectedBubbler.downvoteCount),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(utf8.decode((selectedBubbler.name ?? 'Water Bubbler').codeUnits),
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(
                            "Distance: ${'~${distanceToDisplay(
                              selectedBubbler.distanceTo(currentLocation),
                            )}'}",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                    NavigationButton(waterBubbler: selectedBubbler, size: _buttonsSize),
                    FavoriteBubblerButton(waterBubbler: selectedBubbler, size: _buttonsSize),
                    MaintainBubblerButton(waterBubbler: selectedBubbler, size: _buttonsSize),
                  ].expand((x) => [const SizedBox(width: 5), x]).skip(1).toList(),
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
              color: Colors.blueAccent.withOpacity(0.1),
              // border: Border.all(color: Colors.grey[300]!, width: 1),
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
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LikeDislikeButton(waterBubbler: selectedBubbler),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Padding(
        //   padding: EdgeInsets.only(left: 10.0, right: 10.0),
        //   child: Container(
        //     height: MediaQuery.of(context).size.height * 0.07,
        //     decoration: BoxDecoration(
        //       color: Colors.grey[300],
        //       border: Border.all(color: Colors.grey[300]!, width: 1),
        //       borderRadius: BorderRadius.circular(16),
        //     ),
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //           children: iconDataList.map((iconDataInfo) {
        //             return Icon(
        //               iconDataInfo.icon,
        //               size: MediaQuery.of(context).size.height * 0.035,
        //               color: iconDataInfo.color,
        //             );
        //           }).toList(),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),

        Padding(
          padding: EdgeInsets.only(right: 10.0, left: 10.0),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.1,
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: selectedBubbler.description == null
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No description available.',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          // Ensures the Text widget takes up the available space and wraps text
                          child: Text(
                            utf8.decode((selectedBubbler.description)!.codeUnits),
                            style: TextStyle(fontSize: 12),
                            overflow: TextOverflow.visible,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),

        // TextButton(
        //   onPressed: () {},
        //   child: Text('Read more'),
        // ),

        images.isNotEmpty
            ? ImageGallery(imageUrls: images)
            : Padding(
                padding: EdgeInsets.all(10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    'https://media.istockphoto.com/id/1409329028/vector/no-picture-available-placeholder-thumbnail-icon-illustration-design.jpg?s=170667a&w=0&k=20&c=Q7gLG-xfScdlTlPGFohllqpNqpxsU1jy8feD_fob87U=',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
      ],
    );
  }
}
