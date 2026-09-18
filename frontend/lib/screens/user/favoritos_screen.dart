import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../services/favorito_service.dart';
import '../../widgets/global/favorito_button.dart';

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key});

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  late Future<List<ProductModel>> _favoritosFuture;

  @override
  void initState() {
    super.initState();
    _cargarFavoritos();
  }

  void _cargarFavoritos() {
    setState(() {
      _favoritosFuture = FavoritoService.getFavoritos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Favoritos"),
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: _favoritosFuture,
        builder: (context, snapshot) {
          //CARGANDO
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          //ERROR
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("No se pudieron cargar tus favoritos"),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _cargarFavoritos,
                    child: const Text("Reintentar"),
                  ),
                ],
              ),
            );
          }

          final favoritos = snapshot.data ?? [];

          //LISTA VACIA
          if (favoritos.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    "Aún no tienes productos favoritos",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          //LISTA DE FAVORITOS
          return RefreshIndicator(
            onRefresh: () async => _cargarFavoritos(),
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: favoritos.length,
              itemBuilder: (context, index) {
                final producto = favoritos[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        producto.imagen,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image_not_supported),
                      ),
                    ),
                    title: Text(
                      producto.nombre,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text("\$${producto.precio.toStringAsFixed(0)}"),
                    trailing: FavoritoButton(
                      productoId: producto.id,
                      size: 26,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

