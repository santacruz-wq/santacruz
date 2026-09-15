import 'package:flutter/material.dart';
import '../pedidos_data.dart';
import '../components/pedidos/pedido_card.dart';
import '../components/pedidos/historial_pedidos.dart';
import '../components/pedidos/detalle_pedido.dart';
class MisPedidosPage extends StatefulWidget {
  const MisPedidosPage({super.key});

  @override
  State<MisPedidosPage> createState() => _MisPedidosPageState();
}

class _MisPedidosPageState extends State<MisPedidosPage> {
  // ============================================================
  // COLORES
  // ============================================================

  static const Color cafeOscuro = Color(0xFF4E342E);
  static const Color cafe = Color(0xFF6D4C41);
  static const Color crema = Color(0xFFFFF8E7);
  static const Color fondo = Color(0xFFF8F3EA);
  static const Color dorado = Color(0xFFC49A3A);

  // ============================================================
  // ACTUALIZAR LA PÁGINA
  // ============================================================

  @override
  void initState() {
    super.initState();

    PedidosData.cantidadPedidos.addListener(actualizarPagina);
  }

  @override
  void dispose() {
    PedidosData.cantidadPedidos.removeListener(actualizarPagina);
    super.dispose();
  }

  void actualizarPagina() {
    if (mounted) {
      setState(() {});
    }
  }

  
  
  // ============================================================
  // MOSTRAR DETALLE DEL PEDIDO
  // ============================================================
     void mostrarDetalle(Map<String, dynamic> pedido) {
  showDialog(
    context: context,
    builder: (context) {
      return DetallePedido(
        pedido: pedido,
      );
    },
  );
}

  
  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final pedidos = PedidosData.pedidos;

    return Scaffold(
      backgroundColor: fondo,


  

     
      // ========================================================
      // APP BAR
      // ========================================================
      appBar: AppBar(
        backgroundColor: fondo,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: cafeOscuro),

          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Mis pedidos',
          style: TextStyle(
            color: cafeOscuro,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,
      ),
  

     
      // ========================================================
      // CONTENIDO
      // ========================================================
      body: pedidos.isEmpty

       // ====================================================
          // SIN PEDIDOS
          // ====================================================
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 70,
                    color: cafe.withValues(alpha: 0.45),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'No tienes pedidos todavía',
                    style: TextStyle(
                      color: cafeOscuro,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Cuando realices un pedido aparecerá aquí.',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )

      
          
          // ====================================================
          // LISTA DE PEDIDOS
          // ====================================================
          : ListView(
              padding: const EdgeInsets.fromLTRB(12, 5, 12, 20),

              children: [
                // =================================================
                // ENCABEZADO HISTORIAL
                // =================================================
                HistorialPedidos(
  cantidad: pedidos.length,
),

                // =================================================
                // PEDIDOS
                // =================================================
               ...pedidos.map(
  (pedido) => PedidoCard(
    pedido: pedido,
    onTap: () => mostrarDetalle(pedido),
  ),
),
              ],
            ),
    );
  }
}
