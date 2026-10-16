import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/navigation/menu_navigation.dart';
import '../../providers/auth_provider.dart';
import '../../providers/favorito_provider.dart';
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
  @override
  void initState() {
    super.initState();

    // CARGAMOS LOS FAVORITOS CUANDO SE ABRE LA PANTALLA
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();

      if (auth.usuario != null) {
        context.read<FavoritoProvider>().cargarFavoritos();
      }
    });
  }
class FavoritosScreen extends StatelessWidget {
  final bool showBottomBar;
  const FavoritosScreen({super.key, this.showBottomBar = true});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final favoritos = context.watch<FavoritoProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis favoritos'),
        centerTitle: true,
      ),

      body: _buildBody(
        context,
        auth,
        favoritos,
      ),

      bottomNavigationBar: widget.showBottomBar
          ? BottomMenu(
              currentIndex: 1,
              onItemSelected: (i) =>
                  navegarDesdeMenu(context, i, 1),
      appBar: AppBar(title: const Text('Mis favoritos'), centerTitle: true),
      body: _buildBody(context, auth, favoritos),
      bottomNavigationBar: showBottomBar
          ? BottomMenu(
              currentIndex: 1,
              onItemSelected: (i) => navegarDesdeMenu(context, i, 1),
            )
          : null,
    );
  }

  Widget _buildBody(
    BuildContext context,
    AuthProvider auth,
    FavoritoProvider favoritos,
  ) {
    // =========================
    // SIN SESIÓN
    // =========================

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

              const Text(
                'Inicia sesión para ver tus favoritos',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/login',
                  );
                },
                child: const Text(
                  'Iniciar sesión',
                ),
              ),
            ],
          ),
        ),
      );
    }

    // =========================
    // CARGANDO
    // =========================

    if (favoritos.cargando &&
        favoritos.productos.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // =========================
    // SIN FAVORITOS
    // =========================

    if (favoritos.cargando && favoritos.productos.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (favoritos.productos.isEmpty) {
      return RefreshIndicator(
        onRefresh: favoritos.cargarFavoritos,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 120),

            Icon(
              Icons.favorite_border,
              size: 64,
              color: Colors.grey,
            ),

            SizedBox(height: 16),

            Text(
              'Aún no tienes favoritos',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    // =========================
    // LISTA DE FAVORITOS
    // =========================

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
          final producto =
              favoritos.productos[index];

          return ProductCard(
            id: producto.id,
            name: producto.nombre,
            price: '\$${producto.precio}',
            image: producto.imagen,
            margin: EdgeInsets.zero,
          );
        },
      ),
    );
  }
}