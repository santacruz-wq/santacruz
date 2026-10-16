import 'dart:convert';

import '../core/config/api_config.dart';
import '../core/network/api_client.dart';
import '../models/inventario_model.dart';

class InventarioService {
  // ============================
  // OBTENER TODO EL INVENTARIO
  // ============================

  static Future<List<InventarioModel>> getInventario() async {
    final response = await ApiClient.get(ApiConfig.inventario);
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List<dynamic> lista = data['inventario'] ?? [];

      return lista
          .map((item) => InventarioModel.fromJson(item))
          .toList();
    }

    throw Exception(
      data['message'] ?? 'No se pudo obtener el inventario',
    );
  }

  // ============================
  // OBTENER INVENTARIO POR PRODUCTO
  // ============================

  static Future<InventarioModel> getInventarioPorProducto(
    String productoId,
  ) async {
    final response = await ApiClient.get(
      '${ApiConfig.inventario}/producto/$productoId',
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return InventarioModel.fromJson(data['inventario']);
    }

    throw Exception(
      data['message'] ??
          'No se pudo obtener el inventario del producto',
    );
  }

  // ============================
  // CREAR INVENTARIO DE PRODUCTO
  // ============================

  static Future<InventarioModel> crearInventario({
    required String productoId,
    required int cantidadDisponible,
    required int cantidadMinima,
  }) async {
    final response = await ApiClient.post(
      ApiConfig.inventario,
      {
        'producto': productoId,
        'cantidadDisponible': cantidadDisponible,
        'cantidadMinima': cantidadMinima,
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return InventarioModel.fromJson(data['inventario']);
    }

    throw Exception(
      data['message'] ?? 'No se pudo crear el inventario',
    );
  }

  // ============================
  // CREAR INSUMO INDEPENDIENTE
  // ============================

  static Future<InventarioModel> crearInsumo({
    required String nombreInsumo,
    required String unidadMedida,
    required double cantidadDisponible,
    required double cantidadMinima,
    required double cantidadMaxima,
  }) async {
    final response = await ApiClient.post(
      '${ApiConfig.inventario}/insumos',
      {
        'nombreInsumo': nombreInsumo.trim(),
        'unidadMedida': unidadMedida,
        'cantidadDisponible': cantidadDisponible,
        'cantidadMinima': cantidadMinima,
        'cantidadMaxima': cantidadMaxima,
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return InventarioModel.fromJson(data['inventario']);
    }

    throw Exception(
      data['message'] ?? 'No se pudo crear el insumo',
    );
  }

  // ============================
  // ACTUALIZAR MÍNIMO Y MÁXIMO
  // ============================

  static Future<InventarioModel> actualizarCantidadMinMax({
    required String productoId,
    int? cantidadMinima,
    int? cantidadMaxima,
  }) async {
    final Map<String, dynamic> datos = {};

    if (cantidadMinima != null) {
      datos['cantidadMinima'] = cantidadMinima;
    }

    if (cantidadMaxima != null) {
      datos['cantidadMaxima'] = cantidadMaxima;
    }

    final response = await ApiClient.put(
      '${ApiConfig.inventario}/producto/$productoId/minmax',
      datos,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return InventarioModel.fromJson(data['inventario']);
    }

    throw Exception(
      data['message'] ?? 'No se pudo actualizar el inventario',
    );
  }

  // ============================
  // ACTUALIZAR LÍMITES DE CUALQUIER REGISTRO
  // ============================

  static Future<InventarioModel> actualizarLimitesInventario({
    required String inventarioId,
    required double cantidadMinima,
    required double cantidadMaxima,
  }) async {
    final response = await ApiClient.put(
      '${ApiConfig.inventario}/registro/$inventarioId/minmax',
      {
        'cantidadMinima': cantidadMinima,
        'cantidadMaxima': cantidadMaxima,
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return InventarioModel.fromJson(data['inventario']);
    }

    throw Exception(
      data['message'] ?? 'No se pudieron actualizar los límites',
    );
  }


  // ============================
  // REGISTRAR MOVIMIENTO
  // ============================

  static Future<InventarioModel> registrarMovimiento({
    String? productoId,
    String? inventarioId,
    required String tipo,
    required double cantidad,
    String? motivo,
  }) async {
    final Map<String, dynamic> datos = {
      'tipo': tipo,
      'cantidad': cantidad,
      'motivo': motivo,
    };

    if (inventarioId != null && inventarioId.isNotEmpty) {
      datos['inventarioId'] = inventarioId;
    } else if (productoId != null && productoId.isNotEmpty) {
      datos['producto'] = productoId;
    } else {
      throw Exception(
        'Debes seleccionar un registro de inventario',
      );
    }

    final response = await ApiClient.post(
      '${ApiConfig.inventario}/movimientos',
      datos,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return InventarioModel.fromJson(data['inventario']);
    }

    throw Exception(
      data['message'] ?? 'No se pudo registrar el movimiento',
    );
  }

  // ============================
  // OBTENER TODOS LOS MOVIMIENTOS
  // ============================

  static Future<List<dynamic>> getMovimientos() async {
    final response = await ApiClient.get(
      '${ApiConfig.inventario}/movimientos',
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data['movimientos'] ?? [];
    }

    throw Exception(
      data['message'] ?? 'No se pudieron obtener los movimientos',
    );
  }

  // ============================
  // MOVIMIENTOS POR REGISTRO DE INVENTARIO
  // ============================

  static Future<List<dynamic>> getMovimientosPorInventario(
    String inventarioId,
  ) async {
    final movimientos = await getMovimientos();

    return movimientos.where((movimiento) {
      final inventario = movimiento['inventario'];

      if (inventario is Map) {
        return (inventario['_id'] ?? '').toString() ==
            inventarioId;
      }

      return (inventario ?? '').toString() == inventarioId;
    }).toList();
  }

  // ============================
  // MOVIMIENTOS POR PRODUCTO DEL MENÚ
  // ============================

  static Future<List<dynamic>> getMovimientosPorProducto(
    String productoId,
  ) async {
    final response = await ApiClient.get(
      '${ApiConfig.inventario}/movimientos/producto/$productoId',
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data['movimientos'] ?? [];
    }

    throw Exception(
      data['message'] ??
          'No se pudieron obtener los movimientos del producto',
    );
  }
}