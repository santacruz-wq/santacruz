
import 'package:flutter/material.dart';

class PrivacidadFooter extends StatelessWidget {
  final bool oscuro;
  final Color cafeClaro;
  final Color cafe;

  const PrivacidadFooter({
    super.key,
    required this.oscuro,
    required this.cafeClaro,
    required this.cafe,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.lock_outline,
            color: oscuro
                ? Colors.white30
                : cafeClaro.withValues(alpha: 0.55),
            size: 22,
          ),
          const SizedBox(height: 7),
          Text(
            'Santa Cruz • Privacidad',
            style: TextStyle(
              color: oscuro
                  ? Colors.white38
                  : cafe.withValues(alpha: 0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

