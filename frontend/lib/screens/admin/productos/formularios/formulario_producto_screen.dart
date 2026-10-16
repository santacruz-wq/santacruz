
import 'package:flutter/material.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../models/product_model.dart';
import 'controllers/formulario_producto_controller.dart';
import 'formulario_producto_campos.dart';
import 'formulario_producto_imagen.dart';

class FormularioProductoScreen extends StatefulWidget {
  final ProductModel? producto;

  const FormularioProductoScreen({
    super.key,
    this.producto,
  });

  @override
  State<FormularioProductoScreen> createState() =>
      _FormularioProductoScreenState();
}

class _FormularioProductoScreenState
    extends State<FormularioProductoScreen> {
  late final FormularioProductoController _controller;

  @override
  void initState() {
    super.initState();

    _controller = FormularioProductoController(
      producto: widget.producto,
    );

    _controller.addListener(_actualizarPantalla);
    _controller.cargarCategorias();
  }

  void _actualizarPantalla() {
    if (mounted) setState(() {});
  }

  Future<void> _guardar() async {
    FocusScope.of(context).unfocus();

    if (!_controller.formKey.currentState!.validate()) return;

    final guardado = await _controller.guardar();

    if (!mounted || !guardado) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _controller.editando
              ? 'Producto actualizado correctamente'
              : 'Producto creado correctamente',
        ),
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    _controller.removeListener(_actualizarPantalla);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.crema,
      appBar: AppBar(
        title: Text(
          _controller.editando ? 'Editar producto' : 'Nuevo producto',
        ),
        backgroundColor: AppColors.cremaClaro,
        foregroundColor: AppColors.textoCafe,
      ),
      body: _controller.cargandoCategorias
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _controller.formKey,
              child: ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  FormularioProductoImagen(
                    producto: widget.producto,
                    imagen: _controller.imagen,
                    guardando: _controller.guardando,
                    onSeleccionarImagen: _controller.seleccionarImagen,
                  ),
                  const SizedBox(height: 22),
                  FormularioProductoCampos(
                    categorias: _controller.categorias,
                    categoriaId: _controller.categoriaId,
                    editando: _controller.editando,
                    guardando: _controller.guardando,
                    error: _controller.error,
                    codigoController: _controller.codigoController,
                    nombreController: _controller.nombreController,
                    descripcionController:
                        _controller.descripcionController,
                    precioController: _controller.precioController,
                    onCambiarCategoria: _controller.cambiarCategoria,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed:
                          _controller.guardando ? null : _guardar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.caramelo,
                        foregroundColor: Colors.white,
                      ),
                      icon: _controller.guardando
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save),
                      label: Text(
                        _controller.guardando
                            ? 'Guardando...'
                            : 'Guardar producto',
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
