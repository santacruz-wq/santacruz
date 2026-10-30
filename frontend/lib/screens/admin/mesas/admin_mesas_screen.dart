import 'package:flutter/material.dart';

import '../../../core/config/app_colors.dart';
import '../../../models/mesa_model.dart';
import '../../../services/mesa_service.dart';
import 'widgets/formulario_mesa_dialog.dart';
import 'widgets/tarjeta_mesa.dart';

class AdminMesasScreen extends StatefulWidget {
  const AdminMesasScreen({super.key});

  @override
  State<AdminMesasScreen> createState() => _AdminMesasScreenState();
}

class _AdminMesasScreenState extends State<AdminMesasScreen> {
  List<MesaModel> _mesas = [];
  bool _cargando = true;
  String? _filtro; // null = todas, o libre / ocupada / reservada

  @override
  void initState() {
    super.initState();
    _cargarMesas();
  }

  Future<void> _cargarMesas() async {
    if (mounted) setState(() => _cargando = true);

    try {
      final mesas = await MesaService.getMesas();
      if (!mounted) return;
      setState(() {
        _mesas = mesas;
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _cargando = false);
      _mostrarMensaje('Error al cargar las mesas: $e');
    }
  }

  void _mostrarMensaje(String mensaje) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  Future<void> _abrirFormulario({MesaModel? mesa}) async {
    final resultado = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => FormularioMesaDialog(mesa: mesa),
    );

    if (resultado == true && mounted) {
      await _cargarMesas();
      _mostrarMensaje(
        mesa == null
            ? 'Mesa creada correctamente'
            : 'Mesa actualizada correctamente',
      );
    }
  }

  Future<void> _eliminarMesa(MesaModel mesa) async {
    // UNA MESA EN USO NO SE ELIMINA
    if (!mesa.estaLibre) {
      _mostrarMensaje(
        'No puedes eliminar "${mesa.nombre}" mientras esté ${mesa.estado}.',
      );
      return;
    }

    final confirmado = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar mesa'),
        content: Text(
          '¿Deseas eliminar "${mesa.nombre}"? Dejará de aparecer para los '
          'meseros y no se puede deshacer desde la app.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmado != true || !mounted) return;

    try {
      await MesaService.eliminarMesa(mesa.id);
      if (!mounted) return;
      await _cargarMesas();
      _mostrarMensaje('Mesa eliminada correctamente');
    } catch (e) {
      _mostrarMensaje(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  // "MESA 2" ANTES QUE "MESA 10"
  int _compararNombres(MesaModel a, MesaModel b) {
    final numA = RegExp(r'\d+').firstMatch(a.nombre);
    final numB = RegExp(r'\d+').firstMatch(b.nombre);

    if (numA != null && numB != null) {
      final cmp = int.parse(numA.group(0)!).compareTo(
        int.parse(numB.group(0)!),
      );
      if (cmp != 0) return cmp;
    }
    return a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase());
  }

  List<MesaModel> get _mesasVisibles {
    final lista = _filtro == null
        ? [..._mesas]
        : _mesas.where((m) => m.estado == _filtro).toList();
    lista.sort(_compararNombres);
    return lista;
  }

  Widget _chipFiltro(String etiqueta, String? valor, int cantidad) {
    final seleccionado = _filtro == valor;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text('$etiqueta ($cantidad)'),
        selected: seleccionado,
        showCheckmark: false,
        onSelected: (_) => setState(() => _filtro = valor),
        selectedColor: AppColors.caramelo,
        backgroundColor: AppColors.cremaClaro,
        labelStyle: TextStyle(
          color: seleccionado ? Colors.white : AppColors.textoCafe,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _cuerpoLista() {
    if (_cargando) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.caramelo),
      );
    }

    final visibles = _mesasVisibles;

    return RefreshIndicator(
      onRefresh: _cargarMesas,
      child: visibles.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 80),
                const Icon(
                  Icons.table_restaurant_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 12),
                Text(
                  _mesas.isEmpty
                      ? 'Aún no hay mesas. Crea la primera con el botón de abajo.'
                      : 'No hay mesas con ese estado.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            )
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
              itemCount: visibles.length,
              itemBuilder: (context, index) {
                final mesa = visibles[index];
                return TarjetaMesa(
                  mesa: mesa,
                  onEditar: () => _abrirFormulario(mesa: mesa),
                  onEliminar: () => _eliminarMesa(mesa),
                );
              },
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final libres = _mesas.where((m) => m.estaLibre).length;
    final ocupadas = _mesas.where((m) => m.estaOcupada).length;
    final reservadas = _mesas.where((m) => m.estaReservada).length;

    return Scaffold(
      backgroundColor: AppColors.crema,
      appBar: AppBar(
        title: const Text(
          'Mesas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.crema,
        foregroundColor: AppColors.textoCafe,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Actualizar',
            onPressed: _cargarMesas,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'admin_mesas_crear',
        onPressed: () => _abrirFormulario(),
        backgroundColor: AppColors.caramelo,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Crear mesa'),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                _chipFiltro('Todas', null, _mesas.length),
                _chipFiltro('Libres', 'libre', libres),
                _chipFiltro('Ocupadas', 'ocupada', ocupadas),
                _chipFiltro('Reservadas', 'reservada', reservadas),
              ],
            ),
          ),
          Expanded(child: _cuerpoLista()),
        ],
      ),
    );
  }
}