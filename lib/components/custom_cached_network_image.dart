import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double borderRadius;
  final double? height;
  final double? width;
  final Widget? child;

  const CustomCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.borderRadius = 12.0,
    this.height,
    this.child,
    this.width,

  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder:
          (context, imageProvider) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              image: DecorationImage(image: imageProvider, fit: fit),
            ),
            height: height,
            width: width,
          ),
      placeholder:
          (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
          ),
      errorWidget:
          (context, url, error) => Container(
            height: height,
            width: width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: child ?? Icon(Icons.broken_image, color: Colors.redAccent),
          ),
    );
  }
}
