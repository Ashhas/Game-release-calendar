import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

class GameImage extends StatelessWidget {
  const GameImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.cacheHeight,
    this.cacheWidth,
  });

  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final int? cacheHeight;
  final int? cacheWidth;

  @override
  Widget build(BuildContext context) {
    // Simple, smart defaults based on actual display size
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    final defaultCacheHeight = height != null && height!.isFinite
        ? (height! * devicePixelRatio).round()
        : null;
    final defaultCacheWidth = width != null && width!.isFinite
        ? (width! * devicePixelRatio).round()
        : null;

    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: width,
      fit: fit,
      placeholder: (_, __) => Image.asset(
        'assets/images/placeholder_210_284.png',
        height: height,
        width: width,
        fit: fit,
      ),
      errorWidget: (_, __, ___) => Image.asset(
        'assets/images/placeholder_210_284.png',
        height: height,
        width: width,
        fit: fit,
      ),
      memCacheHeight: cacheHeight ?? defaultCacheHeight,
      memCacheWidth: cacheWidth ?? defaultCacheWidth,
      fadeInDuration: const Duration(milliseconds: 200),
      fadeInCurve: Curves.easeIn,
    );
  }
}
