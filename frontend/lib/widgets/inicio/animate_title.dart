import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final Animation<Offset> titleSlide;
  final Animation<double> titleOpacity;
  final Animation<double> subtitleOpacity;

  const AnimatedTitle({
    super.key,
    required this.title,
    required this.subtitle,
    required this.titleSlide,
    required this.titleOpacity,
    required this.subtitleOpacity,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SlideTransition(
          position: titleSlide,
          child: FadeTransition(
            opacity: titleOpacity,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.w700,
                height: 1.18,
                letterSpacing: 1.1,
              ),
            ),
          ),
        ),

        const SizedBox(height: 10),

        FadeTransition(
          opacity: subtitleOpacity,
          child: Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15.5,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ],
    );
  }
}

