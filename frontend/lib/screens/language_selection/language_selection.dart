import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';
import '../../core/config/app_colors.dart';
import '../../models/pais_idioma.dart';
import '../../widgets/global/search_field.dart';
import '../../widgets/global/empty_state.dart';
import '../../widgets/language_selection/country_language_title.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Idioma> _resultados = idiomasDisponibles;

  void _filtrar(String query) {
    setState(() {
      _resultados = idiomasDisponibles
          .where((i) => i.nombre.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _elegirIdioma(Idioma seleccion) {
    context.read<LanguageProvider>().setIdioma(
          seleccion.codigo,
          seleccion.nombre,
        );
    Navigator.pushReplacementNamed(context, '/menu');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.crema,
      appBar: AppBar(
        backgroundColor: AppColors.crema,
        foregroundColor: AppColors.textoCafe,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Elige tu idioma',
          style: TextStyle(
            color: AppColors.textoCafe,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Escribe tu idioma de origen',
              style: TextStyle(
                color: AppColors.textoCafe,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            SearchField(
              controller: _searchController,
              onChanged: _filtrar,
              hintText: 'Buscar idioma...',
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _resultados.isEmpty
                  ? const EmptyState(message: 'No se encontró ese idioma')
                  : ListView.builder(
                      itemCount: _resultados.length,
                      itemBuilder: (context, index) {
                        final item = _resultados[index];
                        return CountryLanguageTile(
                          item: item,
                          onTap: () => _elegirIdioma(item),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}