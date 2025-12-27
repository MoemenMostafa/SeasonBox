import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:seasonbox/core/enums/item_type.dart';

/// A high-polish animation for saving items and uploading images.
/// Now uses a DotLottie animation for a more dynamic feel.
class BoxySavingIndicator extends StatelessWidget {
  final ItemType itemType;
  final double size;
  final Color? color;

  const BoxySavingIndicator({
    super.key,
    this.itemType = ItemType.other,
    this.size = 200.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? Theme.of(context).colorScheme.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: DotLottieLoader.fromAsset(
            'assets/animations/loader-loop.lottie',
            frameBuilder: (context, dotLottie) {
              if (dotLottie != null && dotLottie.animations.isNotEmpty) {
                return Lottie.memory(
                  dotLottie.animations.values.first,
                  fit: BoxFit.contain,
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                );
              }
            },
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(Icons.error_outline, color: Colors.red),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(seconds: 1),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Text(
              'Boxing your items...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color.withValues(alpha: value),
                letterSpacing: 0.5,
              ),
            );
          },
        ),
      ],
    );
  }
}
