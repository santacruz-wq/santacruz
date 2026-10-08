import 'package:flutter/material.dart';

import '../../core/config/app_colors.dart';
import '../../models/orden_model.dart';
import 'detalle_pedido_screen.dart';
import 'helpers/historial_filtros.dart';
import 'widgets/historial_app_bar.dart';
import 'widgets/historial_buscador.dart';
import 'widgets/historial_error.dart';
import 'widgets/historial_filtro_mesa.dart';
import 'widgets/historial_filtros.dart';
import 'widgets/historial_lista.dart';
import 'widgets/historial_sin_resultados.dart';

class HistorialPedidosScreen extends StatefulWidget {
  const HistorialPedidosScreen({
    super.key,
  });

  @override
  State<HistorialPedidosScreen> createState() =>
      _HistorialPedidosScreenState();
}

class _HistorialPedidosScreenState
    extends State<HistorialPedidosScreen> {
  late Future<List<OrdenModel>> _historialFuture;

  final TextEditingController _buscarController =
      TextEditingController();

  List<OrdenModel> _pedidos = [];

  DateTime? _fechaSeleccionada;
  String? _mesaSeleccionada;

  @override
  void initState() {
    super.initState();

    _historialFuture = _cargarHistorial();

    _buscarController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _buscarController.dispose();
    super.dispose();
  }

  Future<List<OrdenModel>> _cargarHistorial() async {
    final historial = await cargarHistorialPedidos();

    _pedidos = historial;

    return historial;
  }

  Future<void> _recargar() async {
    setState(() {
      _historialFuture = _cargarHistorial();
    });

    await _historialFuture;
  }

  Future<void> _seleccionarFecha() async {
    final fecha = await seleccionarFechaHistorial(
      context,
      _fechaSeleccionada,
    );

    if (fecha != null && mounted) {
      setState(() {
        _fechaSeleccionada = fecha;
      });
    }
  }

  Future<void> _seleccionarMesa() async {
    final mesa = await mostrarFiltroMesa(
      context,
      mesas: mesasDePedidos(_pedidos),
      mesaSeleccionada: _mesaSeleccionada,
    );

    if (mesa == null) {
      return;
    }

    setState(() {
      _mesaSeleccionada =
          mesa == kTodasLasMesas ? null : mesa;
    });
  }

  void _limpiarFiltros() {
    _buscarController.clear();

    setState(() {
      _fechaSeleccionada = null;
      _mesaSeleccionada = null;
    });
  }

  Future<void> _abrirDetalle(String ordenId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetallePedidoScreen(
          ordenId: ordenId,
        ),
      ),
    );

    if (mounted) {
      _recargar();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtrosActivos =
        _fechaSeleccionada != null ||
        _mesaSeleccionada != null ||
        _buscarController.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.crema,
      appBar: HistorialAppBar(
        onRecargar: _recargar,
      ),
      body: FutureBuilder<List<OrdenModel>>(
        future: _historialFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.caramelo,
              ),
            );
          }

          if (snapshot.hasError) {
            return HistorialError(
              error: snapshot.error,
              onReintentar: _recargar,
            );
          }

          final pedidosFiltrados = filtrarPedidos(
            _pedidos,
            busqueda: _buscarController.text,
            mesaSeleccionada: _mesaSeleccionada,
            fechaSeleccionada: _fechaSeleccionada,
          );

          return Column(
            children: [
              HistorialBuscador(
                controller: _buscarController,
              ),
              HistorialFiltros(
                fechaSeleccionada: _fechaSeleccionada,
                mesaSeleccionada: _mesaSeleccionada,
                filtrosActivos: filtrosActivos,
                onSeleccionarFecha: _seleccionarFecha,
                onSeleccionarMesa: _seleccionarMesa,
                onLimpiar: _limpiarFiltros,
              ),

              // RESULTADOS
              Expanded(
                child: pedidosFiltrados.isEmpty
                    ? HistorialSinResultados(
                        filtrosActivos: filtrosActivos,
                        onRefresh: _recargar,
                      )
                    : HistorialLista(
                        pedidos: pedidosFiltrados,
                        onRefresh: _recargar,
                        onAbrirDetalle: _abrirDetalle,
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}