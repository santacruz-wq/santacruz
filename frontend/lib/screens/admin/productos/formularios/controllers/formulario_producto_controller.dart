
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../models/categoria_model.dart';
import '../../../../../models/product_model.dart';
import '../../../../../services/admin_producto_service.dart';
import '../../../../../services/categoria_service.dart';

class FormularioProductoController extends ChangeNotifier {
  FormularioProductoController({this.producto}) {
    if (producto != null) {
      codigoController.text = producto!.productId;
      nombreController.text = producto!.nombre;
      descripcionController.text = producto!.descripcion ?? '';
      precioController.text = producto!.precio.toString();
      categoriaId = producto!.categoriaId;
    }
  }

  final ProductModel? producto;

  final formKey = GlobalKey<FormState>();
  final codigoController = TextEditingController();
  final nombreController = TextEditingController();
  final descripcionController = TextEditingController();
  final precioController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  List<Categoria> categorias = [];
  String? categoriaId;
  XFile? imagen;
  bool cargandoCategorias = true;
  bool guardando = false;
  String? error;

  bool get editando => producto != null;

  Future<void> cargarCategorias() async {
    try {
      final resultado = await CategoriaService.getCategoriasActivas();

      categorias = resultado;

      if (categoriaId != null &&
          !categorias.any((c) => c.id == categoriaId)) {
        categoriaId = null;
      }

      error = null;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      cargandoCategorias = false;
      notifyListeners();
    }
  }

  Future<void> seleccionarImagen() async {
    try {
      final seleccionada = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1200,
      );

      if (seleccionada != null) {
        imagen = seleccionada;
        error = null;
        notifyListeners();
      }
    } catch (e) {
      error = 'No se pudo seleccionar la imagen: $e';
      notifyListeners();
    }
  }

  void cambiarCategoria(String? valor) {
    categoriaId = valor;
    notifyListeners();
  }

  Future<bool> guardar() async {
    if (categorias.isEmpty) {
      error = 'Primero debes crear o activar una categoría.';
      notifyListeners();
      return false;
    }

    if (categoriaId == null ||
        !categorias.any((c) => c.id == categoriaId)) {
      error = 'Selecciona una categoría activa.';
      notifyListeners();
      return false;
    }

    if (!editando && imagen == null) {
      error = 'Selecciona una imagen para el producto.';
      notifyListeners();
      return false;
    }

    guardando = true;
    error = null;
    notifyListeners();

    bool guardado = false;

    try {
      if (editando) {
        await AdminProductoService.actualizarProducto(
          id: producto!.id,
          nombre: nombreController.text,
          descripcion: descripcionController.text,
          precio: precioController.text,
          categoriaId: categoriaId!,
          imagen: imagen,
        );
      } else {
        await AdminProductoService.crearProducto(
          productId: codigoController.text,
          nombre: nombreController.text,
          descripcion: descripcionController.text,
          precio: precioController.text,
          categoriaId: categoriaId!,
          imagen: imagen!,
        );
      }

      guardado = true;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      guardando = false;
      notifyListeners();
    }

    return guardado;
  }

  @override
  void dispose() {
    codigoController.dispose();
    nombreController.dispose();
    descripcionController.dispose();
    precioController.dispose();
    super.dispose();
  }
}
