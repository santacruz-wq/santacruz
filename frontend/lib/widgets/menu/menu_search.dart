import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';

class MenuSearch extends StatelessWidget {
  final Function(String) onChanged;

  const MenuSearch({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 62,
        decoration: BoxDecoration(
          color: const Color(0xFFF2D09D),
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: lang.t('buscar'),
            hintStyle: const TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
            prefixIcon: const Icon(Icons.search, color: Colors.black, size: 27),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 19),
          ),
        ),
      ),
    );
  }
}