import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ImageGallery extends StatelessWidget {
  final List<String> imageUrls;

  const ImageGallery({required this.imageUrls, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: SizedBox(
        height: 350,
        child: StaggeredGridView.countBuilder(
          crossAxisCount: 3,
          itemCount: imageUrls.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(imageUrls[index]),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
          staggeredTileBuilder: (int index) => StaggeredTile.count(1, index.isEven ? 1.5 : 1),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
        ),
      ),
    );
  }
}
