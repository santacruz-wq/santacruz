
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

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
      destacado = producto!.destacado;
    }
  }

  final ProductModel? producto;

  final formKey = GlobalKey<FormState>();
  final codigoController = TextEditingController();
  final nombreController = TextEditingController();
  final descripcionController = TextEditingController();
  final precioController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();
  final ImageCropper _imageCropper = ImageCropper();

  List<Categoria> categorias = [];
  String? categoriaId;
  XFile? imagen;

  bool destacado = false;
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

  // Seleccionar una imagen y abrir el editor de recorte.
  Future<void> seleccionarImagen({
    ImageSource origen = ImageSource.gallery,
  }) async {
    try {
      final seleccionada = await _imagePicker.pickImage(
        source: origen,
      );

      if (seleccionada == null) return;

      // Abrir editor para centrar, ampliar y recortar.
      final recortada = await _imageCropper.cropImage(
        sourcePath: seleccionada.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 90,
        maxWidth: 1200,
        maxHeight: 1200,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Ajustar imagen',
            toolbarColor: Colors.brown,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: Colors.brown,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
            hideBottomControls: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9,
            ],
          ),
          IOSUiSettings(
            title: 'Ajustar imagen',
            aspectRatioLockEnabled: false,
            resetAspectRatioEnabled: true,
            aspectRatioPickerButtonHidden: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9,
            ],
          ),
        ],
      );

      // Si cancela el recorte, conserva la imagen anterior.
      if (recortada == null) return;

      imagen = XFile(recortada.path);
      error = null;
      notifyListeners();
    } catch (e) {
      error = origen == ImageSource.camera
          ? 'No se pudo tomar o ajustar la foto: $e'
          : 'No se pudo seleccionar o ajustar la imagen: $e';

      notifyListeners();
    }
  }

  void cambiarCategoria(String? valor) {
    categoriaId = valor;
    notifyListeners();
  }

  void cambiarDestacado(bool valor) {
    destacado = valor;
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
          destacado: destacado,
        );
      } else {
        await AdminProductoService.crearProducto(
          productId: codigoController.text,
          nombre: nombreController.text,
          descripcion: descripcionController.text,
          precio: precioController.text,
          categoriaId: categoriaId!,
          imagen: imagen!,
          destacado: destacado,
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
