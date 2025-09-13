import 'package:flutter/material.dart';

class NetworkImageWidget extends StatefulWidget {
  final String imageUrl;
  final String? fallbackAsset;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? loadingWidget;
  final Widget? errorWidget;

  const NetworkImageWidget({
    super.key,
    required this.imageUrl,
    this.fallbackAsset,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.loadingWidget,
    this.errorWidget,
  });

  @override
  State<NetworkImageWidget> createState() => _NetworkImageWidgetState();
}

class _NetworkImageWidgetState extends State<NetworkImageWidget> {
  bool _hasError = false;

  bool _isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null &&
        uri.hasAbsolutePath &&
        (uri.isScheme("http") || uri.isScheme("https"));
  }

  @override
  Widget build(BuildContext context) {
    final loading =
        widget.loadingWidget ??
        const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );

    final fallbackImage =
        widget.fallbackAsset != null
            ? Image.asset(
              widget.fallbackAsset!,
              width: widget.width,
              height: widget.height,
              fit: widget.fit,
            )
            : widget.errorWidget ??
                Container(
                  width: widget.width,
                  height: widget.height,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                );

    Widget finalImage;

    if (!_isValidUrl(widget.imageUrl) || _hasError) {
      finalImage = fallbackImage;
    } else {
      finalImage = Image.network(
        widget.imageUrl,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return loading;
        },
        errorBuilder: (context, error, stackTrace) {
          debugPrint('❌ Image failed to load: $error');
          setState(() => _hasError = true);
          return fallbackImage;
        },
      );
    }

    if (widget.borderRadius != null) {
      finalImage = ClipRRect(
        borderRadius: widget.borderRadius!,
        child: finalImage,
      );
    }

    return finalImage;
  }
}
