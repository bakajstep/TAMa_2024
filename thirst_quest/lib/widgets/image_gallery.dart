import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:thirst_quest/widgets/network_image_with_loading.dart';

class ImageGallery extends StatelessWidget {
  final List<String> imageUrls;

  const ImageGallery({required this.imageUrls, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: StaggeredGridView.countBuilder(
        crossAxisCount: 3,
        itemCount: imageUrls.length,
        itemBuilder: (BuildContext context, int index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
              ),
              child: NetworkImageWithLoading(imageUrl: imageUrls[index]),
            ),
          );
        },
        staggeredTileBuilder: (int index) => StaggeredTile.count(1, index.isEven ? 1.5 : 1),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }
}
