import 'package:flutter/material.dart';

import '../idioma_data.dart';
import '../notificaciones_data.dart';

class NotificacionesPage extends StatefulWidget {
  const NotificacionesPage({super.key});

  @override
  State<NotificacionesPage> createState() => _NotificacionesPageState();
}

class _NotificacionesPageState extends State<NotificacionesPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controlador;

  late Animation<double> _opacidad;
  late Animation<Offset> _deslizamiento;

  @override
  void initState() {
    super.initState();

    _controlador = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _opacidad = CurvedAnimation(
      parent: _controlador,
      curve: Curves.easeOut,
    );

    _deslizamiento = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controlador,
        curve: Curves.easeOutCubic,
      ),
    );

    _controlador.forward();
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  // ================================================================
  // COLORES
  // ================================================================

  Color get fondoActual =>
      IdiomaData.modoOscuro.value
          ? const Color(0xFF2A211D)
          : const Color(0xFFFFFBF5);

  Color get tarjetaActual =>
      IdiomaData.modoOscuro.value
          ? const Color(0xFF3A2D27)
          : Colors.white;

  Color get textoPrincipal =>
      IdiomaData.modoOscuro.value
          ? const Color(0xFFFFF8E7)
          : const Color(0xFF4E342E);

  Color get textoSecundario =>
      IdiomaData.modoOscuro.value
          ? const Color(0xFFE0D2C8)
          : Colors.black54;

  Color get iconoFondo =>
      IdiomaData.modoOscuro.value
          ? const Color(0xFF4A3931)
          : const Color(0xFFF7F1E8);

  // ================================================================
  // CREAR NOTIFICACIÓN DE PRUEBA
  // ================================================================

  void crearNotificacionPrueba() {
    final bool es =
        IdiomaData.idioma.value.languageCode == 'es';

    NotificacionesData.agregarNotificacion(
      pedido: '#004',
      mensaje: es
          ? 'Tu pedido ha sido confirmado y está siendo preparado.'
          : 'Your order has been confirmed and is being prepared.',
      estado: 'confirmado',
      minutos: 25,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          es
              ? 'Notificación de prueba creada'
              : 'Test notification created',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ================================================================
  // ICONO SEGÚN ESTADO
  // ================================================================

  IconData _iconoEstado(String estado) {
    switch (estado.toLowerCase()) {
      case 'confirmado':
        return Icons.check_circle_outline;

      case 'preparando':
        return Icons.restaurant_outlined;

      case 'en camino':
        return Icons.delivery_dining_outlined;

      case 'entregado':
        return Icons.home_outlined;

      default:
        return Icons.notifications_outlined;
    }
  }

  // ================================================================
  // COLOR DEL ICONO
  // ================================================================

  Color _colorIcono(String estado) {
    switch (estado.toLowerCase()) {
      case 'confirmado':
        return const Color(0xFFDDB447);

      case 'preparando':
        return const Color(0xFF8D6E63);

      case 'en camino':
        return const Color(0xFF6F4E37);

      case 'entregado':
        return const Color(0xFF4E342E);

      default:
        return const Color(0xFFDDB447);
    }
  }

  // ================================================================
  // TEXTO DEL ESTADO
  // ================================================================

  String _textoEstado(String estado, bool es) {
    switch (estado.toLowerCase()) {
      case 'confirmado':
        return es ? 'Pedido confirmado' : 'Order confirmed';

      case 'preparando':
        return es ? 'Pedido en preparación' : 'Order being prepared';

      case 'en camino':
        return es ? 'Pedido en camino' : 'Order on the way';

      case 'entregado':
        return es ? 'Pedido entregado' : 'Order delivered';

      default:
        return estado;
    }
  }

  // ================================================================
  // TARJETA DE NOTIFICACIÓN
  // ================================================================

  Widget tarjetaNotificacion(
    Notificacion notificacion,
    int index,
    bool es,
    bool oscuro,
  ) {
    final Color colorIcono =
        _colorIcono(notificacion.estado);

    return Dismissible(
      key: ValueKey(
        '${notificacion.pedido}_${notificacion.fecha.microsecondsSinceEpoch}',
      ),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 12,
        ),
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(18),
        ),
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 28,
        ),
      ),
      onDismissed: (_) {
        NotificacionesData.eliminarNotificacion(index);
      },
      child: GestureDetector(
        onTap: () {
          NotificacionesData.marcarComoLeida(index);
        },
        child: Container(
          margin: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 12,
          ),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: tarjetaActual,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(
                  oscuro ? 0.18 : 0.06,
                ),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ======================================================
              // ICONO
              // ======================================================

              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: iconoFondo,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  _iconoEstado(notificacion.estado),
                  color: colorIcono,
                  size: 27,
                ),
              ),

              const SizedBox(width: 14),

              // ======================================================
              // INFORMACIÓN
              // ======================================================

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notificacion.pedido,
                            style: TextStyle(
                              color: textoPrincipal,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // INDICADOR DE NO LEÍDA
                        if (!notificacion.leida)
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Color(0xFFDDB447),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Text(
                      _textoEstado(
                        notificacion.estado,
                        es,
                      ),
                      style: TextStyle(
                        color: colorIcono,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      notificacion.mensaje,
                      style: TextStyle(
                        color: textoSecundario,
                        fontSize: 14,
                        height: 1.35,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Icon(
                          Icons.access_time_outlined,
                          size: 16,
                          color: textoSecundario,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          es
                              ? 'Tiempo estimado: ${notificacion.minutos} min'
                              : 'Estimated time: ${notificacion.minutos} min',
                          style: TextStyle(
                            color: textoSecundario,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================================================================
  // BUILD
  // ================================================================

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: IdiomaData.idioma,
      builder: (context, idioma, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: IdiomaData.modoOscuro,
          builder: (context, oscuro, child) {
            final bool es =
                idioma.languageCode == 'es';

            return Scaffold(
              backgroundColor: fondoActual,

              // ====================================================
              // APP BAR
              // ====================================================

              appBar: AppBar(
                backgroundColor: oscuro
                    ? const Color(0xFF1E1714)
                    : const Color(0xFF4E342E),
                foregroundColor: Colors.white,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  es ? 'Notificaciones' : 'Notifications',
                  style: const TextStyle(
                    fontFamily: 'Arial',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: [
                  ValueListenableBuilder<List<Notificacion>>(
                    valueListenable:
                        NotificacionesData.notificaciones,
                    builder: (
                      context,
                      listaNotificaciones,
                      child,
                    ) {
                      final int cantidad =
                          NotificacionesData
                              .cantidadNoLeidas;

                      if (cantidad == 0) {
                        return const SizedBox.shrink();
                      }

                      return IconButton(
                        tooltip: es
                            ? 'Marcar todas como leídas'
                            : 'Mark all as read',
                        onPressed: () {
                          NotificacionesData
                              .marcarTodasComoLeidas();
                        },
                        icon: const Icon(
                          Icons.done_all,
                        ),
                      );
                    },
                  ),
                ],
              ),

              // ====================================================
              // BODY
              // ====================================================

              body: FadeTransition(
                opacity: _opacidad,
                child: SlideTransition(
                  position: _deslizamiento,
                  child: ValueListenableBuilder<
                      List<Notificacion>>(
                    valueListenable:
                        NotificacionesData.notificaciones,
                    builder: (
                      context,
                      listaNotificaciones,
                      child,
                    ) {
                      // =================================================
                      // SIN NOTIFICACIONES
                      // =================================================

                      if (listaNotificaciones.isEmpty) {
                        return Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.all(30),
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 90,
                                  height: 90,
                                  decoration:
                                      BoxDecoration(
                                    color: iconoFondo,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons
                                        .notifications_none_outlined,
                                    size: 45,
                                    color: textoPrincipal,
                                  ),
                                ),

                                const SizedBox(height: 22),

                                Text(
                                  es
                                      ? 'No tienes notificaciones'
                                      : 'No notifications',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: textoPrincipal,
                                    fontSize: 20,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  es
                                      ? 'Aquí aparecerán las novedades de tus pedidos'
                                      : 'Your order updates will appear here',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: textoSecundario,
                                    fontSize: 14,
                                    height: 1.4,
                                  ),
                                ),

                                const SizedBox(height: 28),

                                // ======================================
                                // BOTÓN TEMPORAL DE PRUEBA
                                // ======================================

                                ElevatedButton.icon(
                                  onPressed:
                                      crearNotificacionPrueba,
                                  icon: const Icon(
                                    Icons.notifications_active_outlined,
                                  ),
                                  label: Text(
                                    es
                                        ? 'Crear notificación de prueba'
                                        : 'Create test notification',
                                  ),
                                  style:
                                      ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color(0xFFDDB447),
                                    foregroundColor:
                                        Colors.white,
                                    padding:
                                        const EdgeInsets
                                            .symmetric(
                                      horizontal: 20,
                                      vertical: 13,
                                    ),
                                    shape:
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                        14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      // =================================================
                      // LISTA DE NOTIFICACIONES
                      // =================================================

                      return Column(
                        children: [
                          // =============================================
                          // BOTÓN TEMPORAL
                          // =============================================

                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(
                              16,
                              16,
                              16,
                              8,
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed:
                                    crearNotificacionPrueba,
                                icon: const Icon(
                                  Icons.add_alert_outlined,
                                ),
                                label: Text(
                                  es
                                      ? 'Crear notificación de prueba'
                                      : 'Create test notification',
                                ),
                                style:
                                    OutlinedButton.styleFrom(
                                  foregroundColor:
                                      const Color(0xFFDDB447),
                                  side: const BorderSide(
                                    color: Color(0xFFDDB447),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                      14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // =============================================
                          // LISTA
                          // =============================================

                          Expanded(
                            child: ListView.builder(
                              padding:
                                  const EdgeInsets.only(
                                top: 8,
                                bottom: 20,
                              ),
                              itemCount:
                                  listaNotificaciones.length,
                              itemBuilder:
                                  (context, index) {
                                final notificacion =
                                    listaNotificaciones[
                                        index];

                                return tarjetaNotificacion(
                                  notificacion,
                                  index,
                                  es,
                                  oscuro,
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}