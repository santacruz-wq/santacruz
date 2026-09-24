
import 'package:flutter/material.dart';

import '../favoritos_data.dart';
import '../idioma_data.dart';
import '../notificaciones_data.dart';

import 'configuracion_page.dart';
import 'mis_pedidos_page.dart';
import 'direcciones_page.dart';
import 'notificaciones_page.dart';

import '../components/perfil/perfil_header.dart';
import '../components/perfil/perfil_opcion.dart';
import '../components/perfil/perfil_footer.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  static const Color cafeOscuro = Color(0xFF4E342E);
  static const Color cafeClaro = Color(0xFF8D6E63);
  static const Color crema = Color(0xFFF7F1E8);
  static const Color cremaClara = Color(0xFFFFFBF5);
  static const Color dorado = Color(0xFFDDB447);

  String t(String clave) {
    return IdiomaData.texto(clave);
  }

  // ================================================================
  // MIS PEDIDOS
  // ================================================================

  void misPedidos() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MisPedidosPage(),
      ),
    );
  }

  // ================================================================
  // MIS FAVORITOS
  // ================================================================

  void misFavoritos() {
    final bool es = IdiomaData.idioma.value.languageCode == 'es';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: cafeOscuro,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        content: Text(
          es
              ? 'Tienes ${FavoritosData.favoritos.length} productos guardados.'
              : 'You have ${FavoritosData.favoritos.length} saved products.',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ================================================================
  // MIS DIRECCIONES
  // ================================================================

  void misDirecciones() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DireccionesPage(),
      ),
    );
  }

  // ================================================================
  // CONFIGURACIÓN
  // ================================================================

  void configuracion() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ConfiguracionPage(),
      ),
    );
  }

  // ================================================================
  // NOTIFICACIONES
  // ================================================================

  void abrirNotificaciones() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotificacionesPage(),
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
      builder: (context, locale, child) {
        final bool es = locale.languageCode == 'es';

        final int cantidadFavoritos =
            FavoritosData.favoritos.length;

        final bool oscuro =
            Theme.of(context).brightness == Brightness.dark;

        final Color fondoPagina =
            oscuro ? const Color(0xFF1E1714) : crema;

        final Color fondoTarjeta =
            oscuro ? const Color(0xFF2B211D) : cremaClara;

        final Color colorSeparador = oscuro
            ? cafeClaro.withOpacity(0.20)
            : const Color(0xFFE5D5C8);

        return Scaffold(
          backgroundColor: fondoPagina,

          // ==========================================================
          // APP BAR
          // ==========================================================

          appBar: AppBar(
            backgroundColor: fondoPagina,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: dorado,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 21,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  es ? 'Mi cuenta' : 'My account',
                  style: TextStyle(
                    color: oscuro ? Colors.white : cafeOscuro,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // ==========================================================
          // CONTENIDO
          // ==========================================================

          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
            child: Column(
              children: [
                // ====================================================
                // CABECERA
                // ====================================================

                PerfilHeader(
                  oscuro: oscuro,
                  es: es,
                ),

                const SizedBox(height: 18),

                // ====================================================
                // OPCIONES
                // ====================================================

                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: fondoTarjeta,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: oscuro
                          ? cafeClaro.withOpacity(0.22)
                          : const Color(0xFFF3D27A)
                              .withOpacity(0.65),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(
                          oscuro ? 0.20 : 0.07,
                        ),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),

                  child: Column(
                    children: [
                      // ==================================================
                      // MIS PEDIDOS
                      // ==================================================

                      PerfilOpcion(
                        icono: Icons.shopping_bag_outlined,
                        titulo: t('mis_pedidos'),
                        subtitulo: es
                            ? 'Consulta tus pedidos'
                            : 'View your orders',
                        onTap: misPedidos,
                        oscuro: oscuro,
                      ),

                      Divider(
                        height: 1,
                        indent: 14,
                        endIndent: 14,
                        color: colorSeparador,
                      ),

                      // ==================================================
                      // MIS FAVORITOS
                      // ==================================================

                      PerfilOpcion(
                        icono: Icons.favorite_outline,
                        titulo: t('mis_favoritos'),
                        subtitulo: es
                            ? '$cantidadFavoritos productos guardados'
                            : '$cantidadFavoritos saved products',
                        onTap: misFavoritos,
                        oscuro: oscuro,
                      ),

                      Divider(
                        height: 1,
                        indent: 14,
                        endIndent: 14,
                        color: colorSeparador,
                      ),

                      // ==================================================
                      // NOTIFICACIONES
                      // ==================================================

                      ValueListenableBuilder<List<Notificacion>>(
                        valueListenable:
                            NotificacionesData.notificaciones,
                        builder: (
                          context,
                          listaNotificaciones,
                          child,
                        ) {
                          final int cantidadNoLeidas =
                              NotificacionesData.cantidadNoLeidas;

                          return Stack(
                            children: [
                              PerfilOpcion(
                                icono:
                                    Icons.notifications_outlined,
                                titulo: es
                                    ? 'Notificaciones'
                                    : 'Notifications',
                                subtitulo: cantidadNoLeidas > 0
                                    ? es
                                        ? '$cantidadNoLeidas nuevas'
                                        : '$cantidadNoLeidas new'
                                    : es
                                        ? 'No tienes novedades'
                                        : 'No new notifications',
                                onTap: abrirNotificaciones,
                                oscuro: oscuro,
                              ),

                              // ==================================================
                              // CONTADOR
                              // ==================================================

                              if (cantidadNoLeidas > 0)
                                Positioned(
                                  right: 22,
                                  top: 14,
                                  child: Container(
                                    constraints:
                                        const BoxConstraints(
                                      minWidth: 22,
                                      minHeight: 22,
                                    ),
                                    padding:
                                        const EdgeInsets.symmetric(
                                      horizontal: 6,
                                    ),
                                    decoration:
                                        const BoxDecoration(
                                      color: Color(0xFFDDB447),
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      cantidadNoLeidas > 99
                                          ? '99+'
                                          : '$cantidadNoLeidas',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),

                      Divider(
                        height: 1,
                        indent: 14,
                        endIndent: 14,
                        color: colorSeparador,
                      ),

                      // ==================================================
                      // MIS DIRECCIONES
                      // ==================================================

                      PerfilOpcion(
                        icono: Icons.location_on_outlined,
                        titulo: t('mis_direcciones'),
                        subtitulo: es
                            ? 'Gestiona tus direcciones'
                            : 'Manage your addresses',
                        onTap: misDirecciones,
                        oscuro: oscuro,
                      ),

                      Divider(
                        height: 1,
                        indent: 14,
                        endIndent: 14,
                        color: colorSeparador,
                      ),

                      // ==================================================
                      // CONFIGURACIÓN
                      // ==================================================

                      PerfilOpcion(
                        icono: Icons.settings_outlined,
                        titulo: t('configuracion'),
                        subtitulo: es
                            ? 'Personaliza la aplicación'
                            : 'Customize the application',
                        onTap: configuracion,
                        oscuro: oscuro,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // ====================================================
                // PIE DE PÁGINA
                // ====================================================

                PerfilFooter(
                  oscuro: oscuro,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


