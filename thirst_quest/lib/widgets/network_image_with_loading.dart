import 'package:flutter/material.dart';
import 'package:thirst_quest/widgets/loading.dart';

class NetworkImageWithLoading extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;

  const NetworkImageWithLoading({required this.imageUrl, this.fit = BoxFit.cover, this.width, this.height, super.key});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: fit,
      width: width,
      height: height,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Loading();
      },
      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
        return Center(
          child: Icon(Icons.error),
        );
      },
    );
  }
}
