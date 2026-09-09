import 'package:flutter/material.dart';

class AnimatedLogo extends StatelessWidget {
  final String assetPath;
  final double width;
  final double height;
  final Animation<double> scaleAnimation;
  final Animation<double> opacityAnimation;

  const AnimatedLogo({
    super.key,
    required this.assetPath,
    required this.scaleAnimation,
    required this.opacityAnimation,
    this.width = 155,
    this.height = 155,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scaleAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: opacityAnimation.value.clamp(0.0, 1.0),
          child: Transform.scale(scale: scaleAnimation.value, child: child),
        );
      },
      child: Image.asset(assetPath, width: width, height: height),
    );
  }
}