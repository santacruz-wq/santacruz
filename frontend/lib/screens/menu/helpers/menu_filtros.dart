import '../../../models/product_model.dart';
import '../../../models/categoria_model.dart';

List<ProductModel> filtrarPorBusqueda(
  List<ProductModel> productos,
  String busqueda,
) {
  if (busqueda.isEmpty) {
    return productos;
  }

  return productos
      .where(
        (p) => p.nombre
            .toLowerCase()
            .contains(busqueda.toLowerCase()),
      )
      .toList();
}

List<ProductModel> filtrarDestacados(
  List<ProductModel> productos, {
  required String busqueda,
  required int selectedCategory,
  required List<Categoria> categorias,
}) {
  var lista = filtrarPorBusqueda(productos, busqueda);

  if (selectedCategory != 0 && categorias.isNotEmpty) {
    final categoriaId = categorias[selectedCategory - 1].id;

    lista = lista
        .where(
          (p) => p.categoriaId == categoriaId,
        )
        .toList();
  }

  return lista;
}