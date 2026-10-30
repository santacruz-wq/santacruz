
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/navigation/menu_navigation.dart';

import '../../core/config/translation_postres.dart';
import '../../providers/auth_provider.dart';
import '../../providers/favorito_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/global/bottom_menu.dart';
import '../../widgets/menu/product_card.dart';

class FavoritosScreen extends StatefulWidget {
  final bool showBottomBar;

  const FavoritosScreen({
    super.key,
    this.showBottomBar = true,
  });

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  static const Map<String, String> _clavesPostres = {
    'Salpicón con helado': 'postre_salpicon_helado',
    'Merengón tropical': 'postre_merengon_tropical',
    'Esponjado de frutos rojos': 'postre_esponjado_frutos_rojos',
    'Esponjado de cholupa': 'postre_esponjado_cholupa',
    'Esponjado de maracumango': 'postre_esponjado_maracumango',
    'Esponjado de arequipe con coco': 'postre_esponjado_arequipe_coco',
    'Postre de tres leches': 'postre_tres_leches',
    'Postre de Milo': 'postre_milo',
    'Flan de leche asada': 'postre_flan_leche_asada',
    'Flan de café': 'postre_flan_cafe',
    'Torta de chocolate': 'postre_torta_chocolate',
    'Torta Red Velvet': 'postre_torta_red_velvet',
    'Postre de limón': 'postre_limon',
  };

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final auth = context.read<AuthProvider>();

      if (auth.usuario != null) {
        context.read<FavoritoProvider>().cargarFavoritos();
      }
    });
  }

  String _nombreTraducido(String nombre, String idioma) {
    final clave = _clavesPostres[nombre];

    if (clave == null) return nombre;

    return TranslationPostres.obtenerNombre(
      clave: clave,
      idioma: idioma,
      nombreOriginal: nombre,
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final favoritos = context.watch<FavoritoProvider>();
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.t('mis_favoritos')),
        centerTitle: true,
      ),
      body: _buildBody(
        context,
        auth,
        favoritos,
        lang,
      ),
      bottomNavigationBar: widget.showBottomBar
          ? BottomMenu(
              currentIndex: 1,
              onItemSelected: (i) {
                navegarDesdeMenu(context, i, 1);
              },
            )
          : null,
    );
  }

  Widget _buildBody(
    BuildContext context,
    AuthProvider auth,
    FavoritoProvider favoritos,
    LanguageProvider lang,
  ) {
    // Usuario sin sesión.
    if (auth.usuario == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.favorite_border,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                lang.t('inicia_sesion_favoritos'),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text(lang.t('iniciar_sesion')),
              ),
            ],
          ),
        ),
      );
    }

    // Cargando favoritos.
    if (favoritos.cargando && favoritos.productos.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Sin favoritos.
    if (favoritos.productos.isEmpty) {
      return RefreshIndicator(
        onRefresh: favoritos.cargarFavoritos,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 120),
            const Icon(
              Icons.favorite_border,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              lang.t('aun_sin_favoritos'),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }

    // Lista de productos favoritos.
    return RefreshIndicator(
      onRefresh: favoritos.cargarFavoritos,
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          mainAxisExtent: 190,
        ),
        itemCount: favoritos.productos.length,
        itemBuilder: (context, index) {
          final producto = favoritos.productos[index];

          return ProductCard(
            id: producto.id,
            name: _nombreTraducido(
              producto.nombre,
              lang.idiomaCodigo,
            ),
            price: '\$${producto.precio}',
            image: producto.imagen,
            margin: EdgeInsets.zero,
          );
        },
      ),
    );
  }
}