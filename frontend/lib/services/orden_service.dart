import 'dart:convert';

import '../core/config/api_config.dart';
import '../core/network/api_client.dart';
import '../models/orden_model.dart';
import '../models/orden_detalle_model.dart';

class OrdenService {
  // CREAR UNA NUEVA ORDEN

  static Future<OrdenModel> crearOrden({
    required String mesaId,
    required List<Map<String, dynamic>> productos,
  }) async {
    final response = await ApiClient.post(
      ApiConfig.ordenes,
      {
        "mesa": mesaId,
        "productos": productos,
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return OrdenModel.fromJson(
        data["orden"],
      );
    }

    throw Exception(
      data["message"] ?? "No se pudo crear la orden",
    );
  }

  // OBTENER TODAS LAS ÓRDENES

  static Future<List<OrdenModel>> getOrdenes() async {
    final response = await ApiClient.get(
      ApiConfig.ordenes,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List<dynamic> lista =
          data["ordenes"] ?? [];

      return lista
          .map(
            (item) => OrdenModel.fromJson(item),
          )
          .toList();
    }

    throw Exception(
      data["message"] ??
          "No se pudieron obtener las órdenes",
    );
  }

  // OBTENER UNA ORDEN POR ID

  static Future<Map<String, dynamic>> getOrdenPorId(
    String ordenId,
  ) async {
    final response = await ApiClient.get(
      "${ApiConfig.ordenes}/$ordenId",
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final orden = OrdenModel.fromJson(
        data["orden"],
      );

      final List<dynamic> lista =
          data["detalles"] ?? [];

      final detalles = lista
          .map(
            (item) => OrdenDetalleModel.fromJson(item),
          )
          .toList();

      return {
        "orden": orden,
        "detalles": detalles,
      };
    }

    throw Exception(
      data["message"] ??
          "No se pudo obtener la orden",
    );
  }

  // AGREGAR PRODUCTO A UNA ORDEN EXISTENTE
  // SOLO CUANDO LA ORDEN SIGUE PENDIENTE

  static Future<bool> agregarProducto({
    required String ordenId,
    required String productoId,
    required int cantidad,
    String? notas,
  }) async {
    final response = await ApiClient.post(
      "${ApiConfig.ordenes}/$ordenId/productos",
      {
        "producto": productoId,
        "cantidad": cantidad,
        "notas": notas,
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return true;
    }

    throw Exception(
      data["message"] ??
          "No se pudo agregar el producto",
    );
  }

  // CREAR UNA ADICIÓN A UNA ORDEN
  // SE PUEDE USAR AUNQUE LA ORDEN YA ESTÉ EN COCINA

  static Future<bool> crearAdicion({
    required String ordenId,
    required List<Map<String, dynamic>> productos,
  }) async {
    final response = await ApiClient.post(
      "${ApiConfig.ordenes}/$ordenId/adiciones",
      {
        "productos": productos,
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return true;
    }

    throw Exception(
      data["message"] ??
          "No se pudo crear la adición",
    );
  }

  // CAMBIAR ESTADO DE LA ORDEN

  static Future<bool> cambiarEstado(
    String ordenId,
    String estado,
  ) async {
    final response = await ApiClient.patch(
      "${ApiConfig.ordenes}/$ordenId/estado",
      {
        "estado": estado,
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return true;
    }

    throw Exception(
      data["message"] ??
          "No se pudo cambiar el estado de la orden",
    );
  }
}