import 'package:flutter/material.dart';
import '../../../../gen/assets.gen.dart';

/// Animated magnifying icon widget with pulse animation
class AnimatedMagnifyingIconWidget extends StatefulWidget {
  final double width;
  final double height;

  const AnimatedMagnifyingIconWidget({
    super.key,
    this.width = 32,
    this.height = 32,
  });

  @override
  State<AnimatedMagnifyingIconWidget> createState() =>
      _AnimatedMagnifyingIconWidgetState();
}

class _AnimatedMagnifyingIconWidgetState
    extends State<AnimatedMagnifyingIconWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Assets.icons.icMagnifying.image(
        width: widget.width,
        height: widget.height,
      ),
    );
  }
}
