import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:seasonbox/core/enums/item_type.dart';

/// A high-polish, "Masterpiece" animation for saving items and uploading images.
/// Features Boxy playfully tossing data particles into a magical glowing box.
class BoxySavingIndicator extends StatefulWidget {
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
  State<BoxySavingIndicator> createState() => _BoxySavingIndicatorState();
}

class _BoxySavingIndicatorState extends State<BoxySavingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              size: Size(widget.size, widget.size),
              painter: _MagicUploadPainter(
                progress: _controller.value,
                itemType: widget.itemType,
                color: color,
              ),
            );
          },
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

class _MagicUploadPainter extends CustomPainter {
  final double progress;
  final ItemType itemType;
  final Color color;

  _MagicUploadPainter({
    required this.progress,
    required this.itemType,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);

    // 1. Draw Magical Background Glow
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: 0.2),
          color.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: w / 2));
    canvas.drawCircle(center, w / 2, glowPaint);

    // 2. Draw Progress Ring (High-polish)
    final ringPaint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(center, w * 0.45, ringPaint);

    final activeRingPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: w * 0.45),
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      activeRingPaint,
    );

    // 3. Draw The Magic Box (Center-Right)
    final boxRect = Rect.fromCenter(
      center: Offset(w * 0.65, h * 0.7),
      width: w * 0.35,
      height: h * 0.25,
    );
    _drawGlowingBox(canvas, boxRect, progress);

    // 4. Draw Boxy (Center-Left)
    // Boxy performs a "tossing" motion
    final boxyPos = Offset(w * 0.35, h * 0.7);
    final tossCycle = (progress * 4) % 1.0;
    final isTossing = tossCycle > 0.4 && tossCycle < 0.7;

    _drawExpressiveBoxy(
      canvas,
      boxyPos,
      w * 0.4,
      isTossing: isTossing,
      t: progress,
    );

    // 5. Draw Magic Particles (Pixels/Data being tossed)
    _drawMagicParticles(canvas, boxyPos, boxRect.center, tossCycle);

    // 6. Draw Upload Beam
    if (progress > 0.5) {
      _drawUploadBeam(canvas, boxRect.center, (progress - 0.5) * 2);
    }
  }

  void _drawGlowingBox(Canvas canvas, Rect rect, double t) {
    final glow = 0.5 + 0.5 * math.sin(t * math.pi * 8);
    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.3 + 0.2 * glow);
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(8)), fillPaint);
    canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(8)), strokePaint);

    // Magic Shimmer on Box
    final shimmerPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2 * glow)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawRect(rect.inflate(5), shimmerPaint);

    // Logo Hint
    final logoPaint = Paint()..color = color.withValues(alpha: 0.2);
    canvas.drawCircle(rect.center, rect.width * 0.2, logoPaint);
  }

  void _drawExpressiveBoxy(Canvas canvas, Offset pos, double size,
      {required bool isTossing, required double t}) {
    final bodyPaint = Paint()..color = color;

    // Breathing
    final breath = 1.0 + 0.03 * math.sin(t * math.pi * 8);

    canvas.save();
    canvas.translate(pos.dx, pos.dy + size / 2);
    canvas.scale(breath, 1 / breath);
    canvas.translate(-pos.dx, -(pos.dy + size / 2));

    // Body
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(center: pos, width: size, height: size),
            Radius.circular(size * 0.2)),
        bodyPaint);

    // Eyes
    final isBlinking = math.sin(t * math.pi * 12) > 0.98;
    final eyePaint = Paint()..color = Colors.white;
    final eyeY = pos.dy - size * 0.15;
    if (!isBlinking) {
      canvas.drawCircle(
          Offset(pos.dx - size * 0.2, eyeY), size * 0.08, eyePaint);
      canvas.drawCircle(
          Offset(pos.dx + size * 0.2, eyeY), size * 0.08, eyePaint);
    }
    canvas.restore();

    // Arms (Tossing animation)
    final armPaint = Paint()
      ..color = color
      ..strokeWidth = size * 0.1
      ..strokeCap = StrokeCap.round;

    double leftArmAngle = -0.4;
    double rightArmAngle = 0.4;

    if (isTossing) {
      rightArmAngle = -math.pi * 0.6; // Throwing up/forward
    }

    // Right Arm
    canvas.save();
    canvas.translate(pos.dx + size * 0.5, pos.dy);
    canvas.rotate(rightArmAngle);
    canvas.drawLine(Offset.zero, Offset(size * 0.5, 0), armPaint);
    canvas.restore();

    // Left Arm (Holding the "stack")
    canvas.save();
    canvas.translate(pos.dx - size * 0.5, pos.dy);
    canvas.rotate(leftArmAngle);
    canvas.drawLine(Offset.zero, Offset(-size * 0.4, 0), armPaint);
    canvas.restore();
  }

  void _drawMagicParticles(Canvas canvas, Offset start, Offset end, double t) {
    if (t < 0.3) return; // Wait for toss

    final st = (t - 0.3) / 0.7; // Normalized particle journey
    if (st > 1.0) return;

    final particlePaint = Paint()..color = color.withValues(alpha: 0.8);

    // Draw 3 floating items/particles
    for (int i = 0; i < 3; i++) {
      final delay = i * 0.1;
      final kt = (st - delay).clamp(0.0, 1.0);
      if (kt == 0 || kt == 1) continue;

      // Quadratic Bezier path for the toss
      final control = Offset((start.dx + end.dx) / 2, start.dy - 100);
      final pos = _getBezierPoint(start, control, end, kt);

      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(kt * math.pi * 4);

      // Shape based on itemType
      _drawSmallItemShape(canvas, itemType, 15, particlePaint);

      // Trail
      final trailPaint = Paint()
        ..color = color.withValues(alpha: 0.3 * (1 - kt));
      canvas.drawCircle(Offset.zero, 18, trailPaint);

      canvas.restore();
    }
  }

  void _drawUploadBeam(Canvas canvas, Offset start, double t) {
    final beamPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          color.withValues(alpha: 0.6),
          color.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(start.dx - 20, start.dy - 200, 40, 200));

    final beamW = 20.0 * math.sin(t * math.pi);
    canvas.drawRect(
      Rect.fromLTWH(start.dx - beamW / 2, start.dy - (200 * t), beamW, 200 * t),
      beamPaint,
    );

    // Sparkles in beam
    final sparklePaint = Paint()..color = Colors.white.withValues(alpha: 0.8);
    for (int i = 0; i < 5; i++) {
      final sx = start.dx + (math.sin(t * 10 + i) * 15);
      final sy = start.dy - (200 * t * ((i + 1) / 5));
      canvas.drawCircle(Offset(sx, sy), 2, sparklePaint);
    }
  }

  Offset _getBezierPoint(Offset p0, Offset p1, Offset p2, double t) {
    final x =
        (1 - t) * (1 - t) * p0.dx + 2 * (1 - t) * t * p1.dx + t * t * p2.dx;
    final y =
        (1 - t) * (1 - t) * p0.dy + 2 * (1 - t) * t * p1.dy + t * t * p2.dy;
    return Offset(x, y);
  }

  void _drawSmallItemShape(
      Canvas canvas, ItemType type, double size, Paint paint) {
    switch (type) {
      case ItemType.clothes:
        canvas.drawRect(
            Rect.fromCenter(center: Offset.zero, width: size, height: size),
            paint);
        break;
      case ItemType.shoes:
        canvas.drawOval(
            Rect.fromCenter(
                center: Offset.zero, width: size * 1.5, height: size),
            paint);
        break;
      default:
        canvas.drawCircle(Offset.zero, size / 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MagicUploadPainter oldDelegate) => true;
}
