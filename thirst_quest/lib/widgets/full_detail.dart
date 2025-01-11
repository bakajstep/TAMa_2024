import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thirst_quest/api/models/photo.dart';
import 'package:thirst_quest/controllers/draggable_sheet_child_controller.dart';
import 'package:thirst_quest/assets/constants.dart' as constants;
import 'package:thirst_quest/di.dart';
import 'package:thirst_quest/services/photo_service.dart';
import 'package:thirst_quest/states/bubbler_map_state.dart';
import 'package:provider/provider.dart';
import 'package:thirst_quest/states/global_state.dart';
import 'package:thirst_quest/utils/distance_convertor.dart';
import 'package:thirst_quest/assets/assign_color_to_bubbler_votes.dart';
import 'package:thirst_quest/widgets/favorite_bubbler_button.dart';
import 'package:thirst_quest/widgets/navigation_button.dart';
import 'package:thirst_quest/widgets/maintain_bubbler_button.dart';
import 'package:thirst_quest/widgets/like_dislike_button.dart';
import 'package:thirst_quest/widgets/image_gallery.dart';

class FullDetail extends StatefulWidget {
  final DraggableSheetChildController controller;

  const FullDetail({required this.controller, super.key});

  @override
  State<FullDetail> createState() => _FullDetailState();

  static ScrollView build(DraggableSheetChildController controller, ScrollController scrollController) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              FullDetail(controller: controller),
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

class _FullDetailState extends State<FullDetail> {
  final PhotoService photoService = DI.get<PhotoService>();

  final double _buttonsSize = 30.0;

  final ImagePicker _picker = ImagePicker();
  List<XFile>? _selectedImages;

  Future<void> _pickImages() async {
    final List<XFile> pickedImages = await _picker.pickMultiImage();
    if (pickedImages.isNotEmpty) {
      setState(() {
        _selectedImages = pickedImages;
      });
    }
  }

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
    final globalState = context.watch<GlobalState>();
    final user = globalState.user;
    final selectedBubbler = mapState.selectedBubbler!;
    final currentLocation = mapState.currentPosition!;
    final bubblerName = utf8.decode((selectedBubbler.name ?? 'Water Bubbler').codeUnits);
    List<String> images = selectedBubbler.photos.map((photo) => photo.url).toList();
    // images.add('https://d34-a.sdn.cz/d_34/c_img_QK_3/IYU6je.mpo?fl=res,,500,1');
    // images.add('https://d34-a.sdn.cz/d_34/c_img_G_p/oFQQ2j.jpeg?fl=res,,500,1');
    // images.add('https://d34-a.sdn.cz/d_34/c_img_QM_x/mtXrCt.mpo?fl=res,,500,1');
    // images.add('https://d34-a.sdn.cz/d_34/c_img_QJ_u/4mnrGE.mpo?fl=res,,500,1');
    if (images.isEmpty) {
      images.add('https://media.istockphoto.com/id/1409329028/vector/no-picture-available-placeholder-thumbnail-icon-illustration-design.jpg?s=170667a&w=0&k=20&c=Q7gLG-xfScdlTlPGFohllqpNqpxsU1jy8feD_fob87U=');
    }


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
                      Icons.water_drop,
                      size: _buttonsSize + 15,
                      color: assignColorToBubblerVotes(selectedBubbler.upvoteCount, selectedBubbler.downvoteCount),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(bubblerName,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis)),
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
          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0, bottom: 10.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0, top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded( // Add Expanded here to make LikeDislikeButton take available space
                        child: LikeDislikeButton(waterBubbler: selectedBubbler),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.only(right: 10.0, left: 10.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Column(
                      children: [
                        Text(
                          bubblerName,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                      ],
                    )
                  ),

                  Divider(color: Colors.black.withOpacity(0.4), thickness: 1),

                  (selectedBubbler.description == null || selectedBubbler.description!.isEmpty)
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No description available.',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.4),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            constraints: BoxConstraints(
                              minHeight: 50.0,
                            ),
                            child: Text(
                              utf8.decode((selectedBubbler.description)!.codeUnits),
                              style: TextStyle(fontSize: 12),
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(height: 10),
        Stack(
          children: [
            ImageGallery(key: ValueKey(images.length), imageUrls: images),
            if (user.isLoggedIn)
              Align(
                alignment: Alignment.topRight,
                child: Transform.translate(
                  offset: Offset(-_buttonsSize / 2, -5),
                  child: Material(
                    shape: const CircleBorder(),
                    // color: Colors.grey[200],
                    color: Colors.blue[50],
                    child: IconButton(
                      onPressed: () async {
                        await _pickImages();

                        if (_selectedImages != null && _selectedImages!.isNotEmpty) {
                          final uploadFutures = _selectedImages!.map((imageFile) async {
                            final uploadedImageUrl = await photoService.uploadBubblerPhoto(
                              imageFile,
                              selectedBubbler.id,
                              selectedBubbler.osmId,
                            );
                            return uploadedImageUrl;
                          });

                          final newPhotos = await Future.wait(uploadFutures);

                          images.addAll(newPhotos.map((photo) => photo!.url));
                          selectedBubbler.photos.addAll(newPhotos.where((photo) => photo != null).cast<Photo>());
                          mapState.selectedBubbler = selectedBubbler;
                        }
                      },
                      iconSize: _buttonsSize,
                      padding: EdgeInsets.all(5),
                      constraints: BoxConstraints(),
                      style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      icon: const Icon(Icons.add_photo_alternate, color: Colors.black),
                    ),
                  ),
                ),
              ),
          ],
        ),

      ],
    );
  }
}
