import 'package:flutter/material.dart';

class IdiomaData {
  // ============================================================
  // IDIOMA
  // ============================================================

  static final ValueNotifier<Locale> idioma = ValueNotifier<Locale>(
    const Locale('es'),
  );

  // ============================================================
  // MODO OSCURO
  // ============================================================

  static final ValueNotifier<bool> modoOscuro = ValueNotifier<bool>(false);

  // ============================================================
  // CAMBIAR IDIOMA
  // ============================================================

  static void cambiarIdioma(String codigo) {
    idioma.value = Locale(codigo);
  }

  // ============================================================
  // CAMBIAR MODO OSCURO
  // ============================================================

  static void cambiarModoOscuro(bool activar) {
    modoOscuro.value = activar;
  }

  // ============================================================
  // TRADUCCIONES
  // ============================================================

  static String texto(String clave) {
    final es = idioma.value.languageCode == 'es';

    final traducciones = {
      // ============================================================
      // NAVEGACIÓN
      // ============================================================
      'inicio': es ? 'Inicio' : 'Home',
      'productos': es ? 'Productos' : 'Products',
      'ofertas': es ? 'Ofertas' : 'Offers',
      'favoritos': es ? 'Favoritos' : 'Favorites',
      'perfil': es ? 'Perfil' : 'Profile',
      'carrito': es ? 'Carrito' : 'Cart',

      // ============================================================
      // PERFIL
      // ============================================================
      'configuracion': es ? 'Configuración' : 'Settings',
      'mis_pedidos': es ? 'Mis pedidos' : 'My orders',
      'mis_favoritos': es ? 'Mis favoritos' : 'My favorites',
      'mis_direcciones': es ? 'Mis direcciones' : 'My addresses',
      'notificaciones': es ? 'Notificaciones' : 'Notifications',
      'modo_oscuro': es ? 'Modo oscuro' : 'Dark mode',
      'seleccionar_idioma': es ? 'Seleccionar idioma' : 'Select language',
      'privacidad': es ? 'Privacidad' : 'Privacy',
      'acerca_de': es ? 'Acerca de Santa Cruz' : 'About Santa Cruz',
      'cerrar_sesion': es ? 'Cerrar sesión' : 'Log out',
      'espanol': es ? 'Español' : 'Spanish',
      'ingles': es ? 'English' : 'English',
      // ============================================================
// PRIVACIDAD
// ============================================================
'compartir_datos': es
    ? 'Compartir datos'
    : 'Share data',

'compartir_datos_descripcion': es
    ? 'Permitir compartir información para mejorar tu experiencia.'
    : 'Allow sharing information to improve your experience.',

'mostrar_telefono': es
    ? 'Mostrar teléfono'
    : 'Show phone number',

'mostrar_telefono_descripcion': es
    ? 'Permitir que tu número de teléfono sea visible.'
    : 'Allow your phone number to be visible.',

'permitir_ubicacion': es
    ? 'Permitir ubicación'
    : 'Allow location',

'permitir_ubicacion_descripcion': es
    ? 'Permitir el acceso a tu ubicación para mejorar el servicio.'
    : 'Allow access to your location to improve the service.',

'politica_privacidad': es
    ? 'Política de privacidad'
    : 'Privacy policy',

'ver_politica_privacidad': es
    ? 'Consulta cómo protegemos tu información.'
    : 'Learn how we protect your information.',

'politica_privacidad_texto': es
    ? 'En Santa Cruz nos comprometemos a proteger tu privacidad. La información que proporcionas se utiliza únicamente para ofrecerte una mejor experiencia dentro de la aplicación. No compartimos tus datos personales sin tu autorización.'
    : 'At Santa Cruz, we are committed to protecting your privacy. The information you provide is used only to give you a better experience within the application. We do not share your personal data without your authorization.',

'eliminar_datos': es
    ? 'Eliminar datos'
    : 'Delete data',

'eliminar_datos_descripcion': es
    ? 'Eliminar los datos guardados de tu aplicación.'
    : 'Delete the data saved in your application.',

'eliminar_datos_texto': es
    ? '¿Estás seguro de que deseas eliminar tus datos? Esta acción no se puede deshacer.'
    : 'Are you sure you want to delete your data? This action cannot be undone.',

'datos_eliminados': es
    ? 'Datos eliminados correctamente'
    : 'Data deleted successfully',

'eliminar': es
    ? 'ELIMINAR'
    : 'DELETE',

'cerrar': es
    ? 'CERRAR'
    : 'CLOSE',

      // ============================================================
      // OFERTAS
      // ============================================================
      'ofertas_especiales': es
          ? '¡Ofertas especiales! 🔥'
          : 'Special offers! 🔥',

      'disfruta_ofertas': es
          ? 'Disfruta tus productos favoritos a un precio especial.'
          : 'Enjoy your favorite products at a special price.',

      'agregar': es ? 'Agregar' : 'Add',

      // ============================================================
      // INICIO
      // ============================================================
      'que_buscas': es ? '¿Qué estás buscando?' : 'What are you looking for?',

      'resultados_busqueda': es ? 'Resultados de búsqueda' : 'Search results',

      'no_encontramos_productos': es
          ? 'No encontramos productos'
          : 'No products found',

      'bienvenido': es
          ? '¡Bienvenido a Santa Cruz! 👋'
          : 'Welcome to Santa Cruz! 👋',

      'bienvenido_descripcion': es
          ? 'Disfruta nuestros productos y encuentra tus favoritos en un solo lugar.'
          : 'Enjoy our products and find your favorites all in one place.',

      'sabor_que_enamora': es ? '☕ Sabor que enamora' : '☕ A flavor to love',

      'categorias': es ? 'Categorías' : 'Categories',

      'productos_destacados': es ? 'Productos destacados' : 'Featured products',

      'especiales': es ? '✨ Especiales' : '✨ Specials',

      'ver_todos_productos': es
          ? 'Ver todos los productos'
          : 'View all products',

      'ver_producto': es ? 'Ver producto' : 'View product',

      // ============================================================
      // PRODUCTOS
      // ============================================================
      'nuestros_productos': es ? 'Nuestros productos ☕' : 'Our products ☕',

      'descubre_productos': es
          ? 'Descubre nuestros deliciosos postres y tortas.'
          : 'Discover our delicious desserts and cakes.',

      'ver_detalle': es ? 'Ver detalle' : 'View details',

      'agregado_carrito': es ? 'agregado al carrito' : 'added to cart',

      // ============================================================
      // DETALLE DEL PRODUCTO
      // ============================================================
      'detalle_producto': es ? 'Detalle del producto' : 'Product details',

      'descripcion': es ? 'Descripción' : 'Description',

      'cantidad': es ? 'Cantidad' : 'Quantity',

      'agregar_al_carrito': es ? 'AGREGAR AL CARRITO' : 'ADD TO CART',

      'producto_seleccionado': es
          ? 'Producto seleccionado'
          : 'Selected product',

      // ============================================================
      // FAVORITOS
      // ============================================================
      'no_favoritos': es
          ? 'No tienes favoritos todavía'
          : 'You have no favorites yet',

      'agrega_favoritos': es
          ? 'Agrega tus productos favoritos y los encontrarás aquí.'
          : 'Add your favorite products and you will find them here.',

      'producto_favorito': es ? 'Producto favorito' : 'Favorite product',

      'favorito_eliminado': es
          ? 'Producto eliminado de favoritos'
          : 'Product removed from favorites',

      // ============================================================
      // CARRITO
      // ============================================================
      'mi_carrito': es ? 'Mi Carrito' : 'My Cart',

      'carrito_vacio': es ? 'Tu carrito está vacío' : 'Your cart is empty',

      'agrega_productos_carrito': es
          ? 'Agrega algunos productos deliciosos para comenzar tu pedido.'
          : 'Add some delicious products to start your order.',

      'subtotal': es ? 'Subtotal' : 'Subtotal',

      'total': es ? 'TOTAL' : 'TOTAL',

      'comprar_ahora': es ? 'COMPRAR AHORA' : 'BUY NOW',

      'cancelar_pedido': es ? 'CANCELAR PEDIDO' : 'CANCEL ORDER',

      'confirmar_cancelar_pedido': es
          ? '¿Estás seguro de que quieres cancelar todo el pedido? Se eliminarán todos los productos del carrito.'
          : 'Are you sure you want to cancel the entire order? All products will be removed from the cart.',

      'no': es ? 'NO' : 'NO',

      'si_cancelar': es ? 'SÍ, CANCELAR' : 'YES, CANCEL',

      'pedido_cancelado': es
          ? 'Pedido cancelado correctamente'
          : 'Order cancelled successfully',

      'producto_eliminado': es
          ? 'Producto eliminado del carrito'
          : 'Product removed from cart',

      // ============================================================
      // CONFIRMAR PEDIDO
      // ============================================================
      'confirmar_pedido': es ? 'Confirmar pedido' : 'Confirm order',

      'completar_datos': es
          ? 'Por favor completa nombre, teléfono y dirección.'
          : 'Please complete your name, phone number and address.',

      'deseas_confirmar_pedido': es
          ? '¿Deseas confirmar este pedido?'
          : 'Do you want to confirm this order?',

      'cancelar': es ? 'CANCELAR' : 'CANCEL',

      'confirmar': es ? 'CONFIRMAR' : 'CONFIRM',

      'pedido_confirmado': es ? '¡Pedido confirmado!' : 'Order confirmed!',

      'pedido_recibido': es
          ? 'Tu pedido ha sido recibido correctamente.'
          : 'Your order has been received successfully.',

      'volver_inicio': es ? 'VOLVER AL INICIO' : 'BACK TO HOME',

      'revisa_tu_pedido': es ? 'Revisa tu pedido' : 'Review your order',

      'completa_datos_confirmar': es
          ? 'Completa tus datos antes de confirmar.'
          : 'Complete your information before confirming.',

      'datos_entrega': es ? 'Datos de entrega' : 'Delivery information',

      'nombre_completo': es ? 'Nombre completo' : 'Full name',

      'ej_nombre': es ? 'Ej: Juan Pérez' : 'Ex: John Smith',

      'telefono': es ? 'Teléfono' : 'Phone',

      'ej_telefono': es ? 'Ej: 3001234567' : 'Ex: 3001234567',

      'direccion': es ? 'Dirección' : 'Address',

      'ej_direccion': es ? 'Ej: Calle 10 # 5-20' : 'Ex: 10th Street # 5-20',

      'observaciones': es ? 'Observaciones' : 'Notes',

      'ej_observaciones': es
          ? 'Ej: Entregar después de las 5 PM'
          : 'Ex: Deliver after 5 PM',

      'resumen_pedido': es ? 'Resumen del pedido' : 'Order summary',

      'total_pedido': es ? 'TOTAL DEL PEDIDO' : 'ORDER TOTAL',

      'confirmar_pedido_boton': es ? 'CONFIRMAR PEDIDO' : 'CONFIRM ORDER',

      'volver_carrito': es ? 'VOLVER AL CARRITO' : 'BACK TO CART',
    };

    return traducciones[clave] ?? clave;
  }
}
