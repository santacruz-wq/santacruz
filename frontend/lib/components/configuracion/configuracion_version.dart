import 'package:flutter/material.dart';

class ConfiguracionVersion extends StatelessWidget {
  const ConfiguracionVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: Center(
        child: Column(
          children: const [
            Text(
              'Santa Cruz',
              style: TextStyle(
                color: Color(0xFF6F4E37),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Versión 1.0.0',
              style: TextStyle(color: Color(0xFF8D6E63), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
