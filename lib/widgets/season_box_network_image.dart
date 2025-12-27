import 'package:flutter/material.dart';

class SeasonBoxNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const SeasonBoxNetworkImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return _buildErrorWidget();
    }

    return Image.network(
      imageUrl,
      height: height,
      width: width,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder ??
            Container(
              height: height,
              width: width,
              color: Colors.grey.shade100,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                  strokeWidth: 2,
                ),
              ),
            );
      },
      errorBuilder: (context, error, stackTrace) {
        // Log error here if needed
        return errorWidget ?? _buildErrorWidget();
      },
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      height: height,
      width: width,
      color: Colors.grey.shade200,
      child: Icon(
        Icons.image_not_supported_outlined,
        size: (height ?? 48) * 0.4,
        color: Colors.grey,
      ),
    );
  }
}
