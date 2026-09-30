import 'package:flutter/material.dart';

class FadeLinkButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Animation<double> opacityAnimation;

  const FadeLinkButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.opacityAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacityAnimation,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white, width: 1.2),
            ),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}