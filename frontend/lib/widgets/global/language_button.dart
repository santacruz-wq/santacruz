import 'package:flutter/material.dart';

class LanguageButton extends StatelessWidget {
  const LanguageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pushNamed(
          context,
          '/language-selection',
        );
      },
      icon: const Icon(
        Icons.language,
        color: Colors.black,
        size: 22,
      ),
      tooltip: 'Cambiar idioma',
    );
  }
}