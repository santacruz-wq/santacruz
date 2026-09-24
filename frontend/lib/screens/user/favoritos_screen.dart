import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/navigation/menu_navigation.dart';
import '../../providers/auth_provider.dart';
import '../../providers/favorito_provider.dart';
import '../../widgets/global/bottom_menu.dart';
import '../../widgets/menu/product_card.dart'; //AJUSTAR: ruta real de tu ProductCard

class FavoritosScreen extends StatelessWidget {
  const FavoritosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final favoritos = context.watch<FavoritoProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Mis favoritos'), centerTitle: true),
      body: _buildBody(context, auth, favoritos),
      bottomNavigationBar: BottomMenu(
        currentIndex: 1,
        onItemSelected: (i) => navegarDesdeMenu(context, i, 1),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AuthProvider auth,
    FavoritoProvider favoritos,
  ) {
    //SIN SESION: INVITAMOS A INICIAR SESION
    if (auth.usuario == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.favorite_border, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Inicia sesión para ver tus favoritos',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: const Text('Iniciar sesión'),
              ),
            ],
          ),
        ),
      );
    }

    //CARGANDO
    if (favoritos.cargando && favoritos.productos.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    //SIN FAVORITOS
    if (favoritos.productos.isEmpty) {
      return RefreshIndicator(
        onRefresh: favoritos.cargarFavoritos,
        child: ListView(
          children: const [
            SizedBox(height: 120),
            Icon(Icons.favorite_border, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Aún no tienes favoritos',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }

    //LISTA DE FAVORITOS (ARRASTRAR HACIA ABAJO PARA REFRESCAR)
    //LISTA DE FAVORITOS (ARRASTRAR HACIA ABAJO PARA REFRESCAR)
    return RefreshIndicator(
      onRefresh: favoritos.cargarFavoritos,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          mainAxisExtent:
              190, //ALTO FIJO: EVITA OVERFLOW SEGUN EL ANCHO DE PANTALLA
        ),
        itemCount: favoritos.productos.length,
        itemBuilder: (context, index) {
          final producto = favoritos.productos[index];

          return ProductCard(
            id: producto.id,
            name: producto.nombre,
            price:
                '\$${producto.precio}', //AJUSTAR: mismo formato de precio que usas en el menú
            image: producto.imagen,
            margin: EdgeInsets.zero,
          );
        },
      ),
    );
  }
}
