import 'package:flutter/material.dart';

class ImageNetworkProvider {
  static Widget load({
    required String imageUrl,
    String? fallbackAsset,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
    Widget? loadingWidget,
    Widget? errorWidget,
    Color? loaderColor,
    Color? loaderBackgroundColor,
    double loaderStrokeWidth = 2,
    double loaderSize = 24,
  }) {
    bool isValidUrl(String url) {
      final uri = Uri.tryParse(url);
      return uri != null &&
          uri.hasAbsolutePath &&
          (uri.isScheme("http") || uri.isScheme("https"));
    }
    
    final Widget fallbackImage =
        fallbackAsset != null
            ? Image.asset(fallbackAsset, width: width, height: height, fit: fit)
            : errorWidget ??
                Container(
                  width: width,
                  height: height,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                );
    
    final loading = SizedBox(
      height: height,
      child:
          loadingWidget ??
          Center(
            child: SizedBox(
              width: loaderSize,
              height: loaderSize,
              child: CircularProgressIndicator(
                strokeWidth: loaderStrokeWidth,
                valueColor:
                    loaderColor != null
                        ? AlwaysStoppedAnimation<Color>(loaderColor)
                        : null,
                backgroundColor: loaderBackgroundColor,
              ),
            ),
          ),
    );
    
    if (!isValidUrl(imageUrl)) {
      return _wrapWithBorder(fallbackImage, borderRadius);
    }
    
    return _NetworkImageBuilder(
      imageUrl: imageUrl,
      fallback: fallbackImage,
      width: width,
      height: height,
      fit: fit,
      borderRadius: borderRadius,
      loadingWidget: loading,
    );
  }
  
  static Widget _wrapWithBorder(Widget child, BorderRadius? radius) {
    return radius != null
        ? ClipRRect(borderRadius: radius, child: child)
        : child;
  }
}

class _NetworkImageBuilder extends StatefulWidget {
  final String imageUrl;
  final Widget fallback;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget loadingWidget;
  
  const _NetworkImageBuilder({
    required this.imageUrl,
    required this.fallback,
    required this.width,
    required this.height,
    required this.fit,
    required this.borderRadius,
    required this.loadingWidget,
  });
  
  @override
  State<_NetworkImageBuilder> createState() => _NetworkImageBuilderState();
}

class _NetworkImageBuilderState extends State<_NetworkImageBuilder> {
  bool _hasError = false;
  
  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return widget.borderRadius != null
          ? ClipRRect(borderRadius: widget.borderRadius!, child: widget.fallback)
          : widget.fallback;
    }
    
    return Image.network(
      widget.imageUrl,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return widget.borderRadius != null
            ? ClipRRect(borderRadius: widget.borderRadius!, child: child)
            : child;
        }
        return widget.loadingWidget;
      },
      errorBuilder: (context, error, stackTrace) {
        debugPrint('❌ Image load failed: $error');
        // Schedule the state update instead of doing it during build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() => _hasError = true);
          }
        });
        return widget.fallback;
      },
    );
  }
}