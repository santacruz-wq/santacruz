import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Animation<double>? scaleAnimation;
  final Animation<double>? opacityAnimation;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.scaleAnimation,
    this.opacityAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final button = SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF5F0E6),
          foregroundColor: Colors.black87,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );

    if (scaleAnimation == null || opacityAnimation == null) return button;

    return ScaleTransition(
      scale: scaleAnimation!,
      child: FadeTransition(opacity: opacityAnimation!, child: button),
    );
  }
}