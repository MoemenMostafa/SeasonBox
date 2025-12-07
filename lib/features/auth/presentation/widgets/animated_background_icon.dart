import 'package:flutter/material.dart';

class AnimatedBackgroundIcon extends StatefulWidget {
  final IconData icon;
  final double size;
  final int duration;

  const AnimatedBackgroundIcon({
    super.key,
    required this.icon,
    required this.size,
    required this.duration,
  });

  @override
  State<AnimatedBackgroundIcon> createState() => _AnimatedBackgroundIconState();
}

class _AnimatedBackgroundIconState extends State<AnimatedBackgroundIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: widget.duration),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final offset = Tween<Offset>(
                begin: const Offset(0, -0.1), end: const Offset(0, 0.1))
            .animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ));
        return SlideTransition(
          position: offset,
          child: child,
        );
      },
      child: Icon(
        widget.icon,
        size: widget.size,
        color: Colors.white.withValues(alpha: 0.08),
      ),
    );
  }
}
