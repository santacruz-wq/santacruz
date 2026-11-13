
import 'package:flutter/material.dart';
import '../../../../core/config/app_colors.dart';

class PreguntasFrecuentesScreen extends StatelessWidget {
  const PreguntasFrecuentesScreen({super.key});

  final List<Map<String, dynamic>> categorias = const [
    {
      'titulo': 'Cuenta y perfil',
      'icono': Icons.person_outline,
      'preguntas': [
        {
          'pregunta': '¿Cómo puedo crear una cuenta?',
          'respuesta':
              'Ingresa a la opción de registro, completa los datos solicitados y sigue las instrucciones para crear tu cuenta.'
        },
        {
          'pregunta': '¿Qué hago si olvidé mi contraseña?',
          'respuesta':
              'En la pantalla de inicio de sesión selecciona la opción de recuperar contraseña y sigue el procedimiento indicado para restablecerla.'
        },
        {
          'pregunta': '¿Cómo puedo actualizar mis datos personales?',
          'respuesta':
              'Ingresa a tu perfil y utiliza las opciones disponibles para modificar tu información personal.'
        },
        {
          'pregunta': '¿Cómo puedo cambiar mi foto de perfil?',
          'respuesta':
              'Desde tu perfil selecciona tu fotografía y elige una imagen de la cámara o de la galería de tu dispositivo.'
        },
        {
          'pregunta': '¿Cómo puedo cerrar sesión?',
          'respuesta':
              'Ingresa a tu perfil y selecciona la opción Cerrar sesión para salir de tu cuenta.'
        },
      ],
    },
    {
      'titulo': 'Productos y menú',
      'icono': Icons.restaurant_menu,
      'preguntas': [
        {
          'pregunta': '¿Puedo consultar los productos sin iniciar sesión?',
          'respuesta':
              'Sí. Puedes explorar el menú, consultar las categorías, fotografías, descripciones y precios sin necesidad de iniciar sesión.'
        },
        {
          'pregunta': '¿Por qué un producto no aparece disponible?',
          'respuesta':
              'Puede encontrarse agotado temporalmente o haber sido retirado de la publicación del menú por el administrador.'
        },
        {
          'pregunta': '¿Cómo puedo agregar productos a favoritos?',
          'respuesta':
              'Si tienes una cuenta de usuario, puedes seleccionar el icono de corazón en los productos para guardarlos en tu lista de favoritos.'
        },
        {
          'pregunta': '¿Cómo funciona la traducción de los productos?',
          'respuesta':
              'La aplicación utiliza inteligencia artificial para facilitar la traducción de nombres y descripciones de los productos a los idiomas disponibles.'
        },
      ],
    },
    {
      'titulo': 'Pedidos y atención',
      'icono': Icons.shopping_cart_outlined,
      'preguntas': [
        {
          'pregunta': '¿Cómo puedo realizar un pedido?',
          'respuesta':
              'Los pedidos se gestionan mediante las cuentas autorizadas del personal del establecimiento. El mesero registra los productos solicitados por el cliente.'
        },
        {
          'pregunta': '¿Cómo puedo consultar el estado de un pedido?',
          'respuesta':
              'El personal autorizado puede consultar los pedidos y sus estados desde las secciones correspondientes de la aplicación.'
        },
        {
          'pregunta': '¿Se pueden agregar más productos a un pedido?',
          'respuesta':
              'Sí. El mesero puede registrar productos adicionales en un pedido que todavía se encuentre activo.'
        },
        {
          'pregunta': '¿Qué métodos de pago acepta el establecimiento?',
          'respuesta':
              'Los pagos se gestionan directamente en el establecimiento. Se pueden utilizar los medios de pago habilitados por el negocio, como efectivo o transferencia mediante QR.'
        },
      ],
    },
    {
      'titulo': 'Idiomas e intérprete de voz',
      'icono': Icons.record_voice_over,
      'preguntas': [
        {
          'pregunta': '¿Cómo puedo cambiar el idioma de la aplicación?',
          'respuesta':
              'Puedes seleccionar otro idioma desde las opciones de preferencias de tu perfil, cuando estén disponibles para tu tipo de cuenta.'
        },
        {
          'pregunta': '¿Para qué sirve el intérprete de voz?',
          'respuesta':
              'Permite facilitar la comunicación entre el personal y los clientes extranjeros mediante el reconocimiento de voz y la traducción entre idiomas.'
        },
        {
          'pregunta': '¿Necesito permitir el acceso al micrófono?',
          'respuesta':
              'Sí. Para utilizar el intérprete de voz debes conceder el permiso de micrófono cuando el dispositivo lo solicite.'
        },
        {
          'pregunta': '¿Qué hago si la traducción no funciona?',
          'respuesta':
              'Comprueba tu conexión a internet, verifica los permisos del micrófono e intenta nuevamente.'
        },
      ],
    },
    {
      'titulo': 'Funciones del mesero',
      'icono': Icons.room_service_outlined,
      'preguntas': [
        {
          'pregunta': '¿Cómo puedo registrar un pedido?',
          'respuesta':
              'Selecciona una mesa disponible, agrega los productos solicitados y registra el pedido para enviarlo a cocina.'
        },
        {
          'pregunta': '¿Puedo consultar pedidos registrados por otros meseros?',
          'respuesta':
              'Sí. Los pedidos son compartidos entre los meseros autorizados, por lo que pueden consultar y gestionar los pedidos de las mesas.'
        },
        {
          'pregunta': '¿Puedo agregar productos a un pedido existente?',
          'respuesta':
              'Sí. Puedes registrar adiciones a un pedido activo cuando el cliente solicite más productos.'
        },
        {
          'pregunta': '¿Cuándo se libera una mesa?',
          'respuesta':
              'La mesa se libera cuando el pedido correspondiente se marca como pagado o cancelado.'
        },
      ],
    },
    {
      'titulo': 'Funciones de cocina',
      'icono': Icons.soup_kitchen_outlined,
      'preguntas': [
        {
          'pregunta': '¿Cómo recibo los pedidos?',
          'respuesta':
              'Los pedidos registrados por los meseros aparecen en el apartado de cocina para que el personal pueda consultarlos y prepararlos.'
        },
        {
          'pregunta': '¿Cómo actualizo el estado de un pedido?',
          'respuesta':
              'Desde el apartado de cocina puedes actualizar el estado de preparación según el avance del pedido.'
        },
        {
          'pregunta': '¿Cómo puedo informar que un producto está agotado?',
          'respuesta':
              'El personal autorizado puede gestionar la disponibilidad de los productos desde las opciones habilitadas para ello.'
        },
      ],
    },
    {
      'titulo': 'Funciones del administrador',
      'icono': Icons.admin_panel_settings_outlined,
      'preguntas': [
        {
          'pregunta': '¿Cómo puedo agregar un producto?',
          'respuesta':
              'Desde el panel administrativo puedes registrar productos con su nombre, descripción, precio, categoría e imagen.'
        },
        {
          'pregunta': '¿Puedo ocultar un producto sin marcarlo como agotado?',
          'respuesta':
              'Sí. La publicación del producto y su disponibilidad son opciones independientes. Puedes ocultarlo del menú sin cambiar su estado de disponibilidad.'
        },
        {
          'pregunta': '¿Cómo puedo administrar los usuarios?',
          'respuesta':
              'El administrador puede consultar y gestionar las cuentas del personal y asignar los roles permitidos por el sistema.'
        },
        {
          'pregunta': '¿Para qué sirve el inventario?',
          'respuesta':
              'Permite registrar insumos, consultar cantidades disponibles y controlar los movimientos de entrada y salida.'
        },
      ],
    },
    {
      'titulo': 'Conexión y funcionamiento',
      'icono': Icons.wifi_outlined,
      'preguntas': [
        {
          'pregunta': '¿Necesito conexión a internet?',
          'respuesta':
              'Sí. La aplicación requiere conexión a internet para consultar información del servidor, gestionar pedidos y utilizar los servicios de traducción.'
        },
        {
          'pregunta': '¿Qué sucede si pierdo la conexión a internet?',
          'respuesta':
              'Algunas funciones pueden dejar de estar disponibles temporalmente. Comprueba tu conexión e intenta nuevamente cuando se restablezca.'
        },
        {
          'pregunta': '¿Qué hago si la aplicación presenta un error?',
          'respuesta':
              'Intenta cerrar y abrir nuevamente la aplicación. Si el problema continúa, comunícalo al personal responsable del establecimiento.'
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.crema,
      appBar: AppBar(
        title: const Text('Preguntas frecuentes'),
        backgroundColor: AppColors.crema,
        foregroundColor: AppColors.textoCafe,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '¿Tienes alguna duda?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textoCafe,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Encuentra respuestas sobre el funcionamiento de Santa Cruz de la Plazuela.',
            style: TextStyle(
              color: AppColors.cafeMedio,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),

          ...categorias.map((categoria) {
            final preguntas =
                categoria['preguntas'] as List<Map<String, String>>;

            return Card(
              color: AppColors.cremaClaro,
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ExpansionTile(
                leading: Icon(
                  categoria['icono'] as IconData,
                  color: AppColors.cafeMedio,
                ),
                title: Text(
                  categoria['titulo'] as String,
                  style: const TextStyle(
                    color: AppColors.textoCafe,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: preguntas.map((item) {
                  return ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    childrenPadding: const EdgeInsets.fromLTRB(
                      16, 0, 16, 16,
                    ),
                    title: Text(
                      item['pregunta']!,
                      style: const TextStyle(
                        color: AppColors.textoCafe,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    iconColor: AppColors.cafeMedio,
                    collapsedIconColor: AppColors.cafeMedio,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item['respuesta']!,
                          style: const TextStyle(
                            color: AppColors.cafeMedio,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            );
          }),
        ],
      ),
    );
  }
}
