import 'package:flutter/material.dart';

class GameImage extends StatelessWidget {
  const GameImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
  });

  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return FadeInImage.assetNetwork(
      placeholder: 'assets/images/placeholder_210_284.png',
      image: imageUrl,
      height: height,
      width: width,
      fit: fit,
      imageErrorBuilder: (_, __, ___) {
        return Image.asset(
          'assets/images/placeholder_210_284.png',
          height: height,
          width: width,
          fit: fit,
        );
      },
    );
  }
}
