import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';

// =====================================================
// MODELO DE PAÍS E IDIOMA
// =====================================================

class PaisIdioma {
  final String pais;
  final String bandera;
  final String idiomaCodigo;
  final String idiomaNombre;

  const PaisIdioma({
    required this.pais,
    required this.bandera,
    required this.idiomaCodigo,
    required this.idiomaNombre,
  });
}

// =====================================================
// PAÍSES DISPONIBLES
// =====================================================

const List<PaisIdioma> paisesDisponibles = [
  PaisIdioma(
    pais: 'Colombia',
    bandera: '🇨🇴',
    idiomaCodigo: 'es',
    idiomaNombre: 'Español',
  ),
  PaisIdioma(
    pais: 'España',
    bandera: '🇪🇸',
    idiomaCodigo: 'es',
    idiomaNombre: 'Español',
  ),
  PaisIdioma(
    pais: 'México',
    bandera: '🇲🇽',
    idiomaCodigo: 'es',
    idiomaNombre: 'Español',
  ),
  PaisIdioma(
    pais: 'Argentina',
    bandera: '🇦🇷',
    idiomaCodigo: 'es',
    idiomaNombre: 'Español',
  ),
  PaisIdioma(
    pais: 'Estados Unidos',
    bandera: '🇺🇸',
    idiomaCodigo: 'en',
    idiomaNombre: 'English',
  ),
  PaisIdioma(
    pais: 'Reino Unido',
    bandera: '🇬🇧',
    idiomaCodigo: 'en',
    idiomaNombre: 'English',
  ),
  PaisIdioma(
    pais: 'Canadá',
    bandera: '🇨🇦',
    idiomaCodigo: 'en',
    idiomaNombre: 'English',
  ),
  PaisIdioma(
    pais: 'Francia',
    bandera: '🇫🇷',
    idiomaCodigo: 'fr',
    idiomaNombre: 'Français',
  ),
  PaisIdioma(
    pais: 'Brasil',
    bandera: '🇧🇷',
    idiomaCodigo: 'pt',
    idiomaNombre: 'Português',
  ),
  PaisIdioma(
    pais: 'Portugal',
    bandera: '🇵🇹',
    idiomaCodigo: 'pt',
    idiomaNombre: 'Português',
  ),
  PaisIdioma(
    pais: 'Alemania',
    bandera: '🇩🇪',
    idiomaCodigo: 'de',
    idiomaNombre: 'Deutsch',
  ),
  PaisIdioma(
    pais: 'Italia',
    bandera: '🇮🇹',
    idiomaCodigo: 'it',
    idiomaNombre: 'Italiano',
  ),
  PaisIdioma(
    pais: 'China',
    bandera: '🇨🇳',
    idiomaCodigo: 'zh',
    idiomaNombre: '中文',
  ),
  PaisIdioma(
    pais: 'Japón',
    bandera: '🇯🇵',
    idiomaCodigo: 'ja',
    idiomaNombre: '日本語',
  ),
];

// =====================================================
// PALETA DE COLORES
// =====================================================

// Fondo principal
const Color colorCrema = Color(0xFFEED0A0);

// Crema claro
const Color colorCremaClaro = Color(0xFFF8E6C5);

// Crema oscuro
const Color colorCremaOscuro = Color(0xFFE4BF87);

// Fondo de tarjetas
const Color colorTarjeta = Color(0xFFFBD8A6);

// Café para textos
const Color colorTextoCafe = Color(0xFF4A3024);

// Café secundario
const Color colorCafeMedio = Color(0xFF76543D);

// Caramelo
const Color colorCaramelo = Color(0xFFD29540);

// Caramelo claro
const Color colorCarameloClaro = Color(0xFFFFBD5C);

// Dorado
const Color colorDorado = Color(0xFFD8A04B);

// Blanco cálido
const Color colorBlanco = Color(0xFFFFFBF4);


// =====================================================
// PANTALLA DE SELECCIÓN DE IDIOMA
// =====================================================

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState
    extends State<LanguageSelectionScreen> {

  final TextEditingController _searchController =
      TextEditingController();

  List<PaisIdioma> _resultados = paisesDisponibles;

  // ===================================================
  // FILTRAR PAÍSES
  // ===================================================

  void _filtrar(String query) {
    setState(() {
      _resultados = paisesDisponibles
          .where(
            (p) => p.pais
                .toLowerCase()
                .contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  // ===================================================
  // ELEGIR IDIOMA
  // ===================================================

  void _elegirIdioma(PaisIdioma seleccion) {
    context.read<LanguageProvider>().setIdioma(
          seleccion.idiomaCodigo,
          seleccion.idiomaNombre,
        );

    Navigator.pushReplacementNamed(
      context,
      '/menu',
    );
  }

  // ===================================================
  // LIBERAR CONTROLADOR
  // ===================================================

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ===================================================
  // INTERFAZ
  // ===================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // ================================================
      // FONDO PRINCIPAL
      // ================================================

      backgroundColor: colorCrema,

      // ================================================
      // APP BAR
      // ================================================

      appBar: AppBar(
        backgroundColor: colorCrema,
        foregroundColor: colorTextoCafe,
        elevation: 0,
        centerTitle: true,

        title: const Text(
          'Elige tu idioma',
          style: TextStyle(
            color: colorTextoCafe,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ================================================
      // CUERPO
      // ================================================

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            // ==========================================
            // TEXTO PRINCIPAL
            // ==========================================

            const Text(
              'Escribe tu país para elegir tu idioma',
              style: TextStyle(
                color: colorTextoCafe,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            // ==========================================
            // BUSCADOR
            // ==========================================

            TextField(
              controller: _searchController,
              onChanged: _filtrar,

              style: const TextStyle(
                color: colorTextoCafe,
              ),

              decoration: InputDecoration(
                hintText: 'Buscar país...',

                hintStyle: const TextStyle(
                  color: colorCafeMedio,
                ),

                prefixIcon: const Icon(
                  Icons.search,
                  color: colorCaramelo,
                ),

                filled: true,

                fillColor: colorBlanco,

                contentPadding:
                    const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 16,
                ),

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(14),

                  borderSide: BorderSide.none,
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(14),

                  borderSide: BorderSide.none,
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(14),

                  borderSide: const BorderSide(
                    color: colorCaramelo,
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ==========================================
            // LISTA DE PAÍSES
            // ==========================================

            Expanded(
              child: _resultados.isEmpty

                  ? const Center(
                      child: Text(
                        'No se encontró ese país',
                        style: TextStyle(
                          color: colorTextoCafe,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )

                  : ListView.builder(
                      itemCount: _resultados.length,

                      itemBuilder: (context, index) {

                        final item =
                            _resultados[index];

                        // ==================================
                        // TARJETA DEL PAÍS
                        // ==================================

                        return Card(
                          color: colorBlanco,

                          elevation: 0,

                          margin:
                              const EdgeInsets.symmetric(
                            vertical: 5,
                          ),

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(14),
                          ),

                          child: ListTile(

                            // ------------------------------
                            // BANDERA
                            // ------------------------------

                            leading: Text(
                              item.bandera,
                              style: const TextStyle(
                                fontSize: 28,
                              ),
                            ),

                            // ------------------------------
                            // NOMBRE DEL PAÍS
                            // ------------------------------

                            title: Text(
                              item.pais,
                              style: const TextStyle(
                                color: colorTextoCafe,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            // ------------------------------
                            // IDIOMA
                            // ------------------------------

                            subtitle: Text(
                              item.idiomaNombre,
                              style: const TextStyle(
                                color: colorCaramelo,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            // ------------------------------
                            // FLECHA
                            // ------------------------------

                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: colorCaramelo,
                            ),

                            // ------------------------------
                            // SELECCIONAR
                            // ------------------------------

                            onTap: () =>
                                _elegirIdioma(item),
                          ),
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