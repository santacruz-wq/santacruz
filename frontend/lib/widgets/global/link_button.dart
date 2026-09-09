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
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}