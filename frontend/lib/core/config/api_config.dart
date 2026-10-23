class ApiConfig {
  // Backend desplegado en Render
  static const String baseUrl =
      "https://santacruz-dh65.onrender.com/api";

  static const String login = "$baseUrl/login";
  static const String registrar = "$baseUrl/usuarios/registrar";

  // Recuperar contraseña
  static const String recuperarSolicitar = "$baseUrl/recuperar/solicitar";
  static const String recuperarCambiar = "$baseUrl/recuperar/cambiar";

  static const String verificarCodigo =
      "$baseUrl/usuarios/verificar-codigo";
  static const String reenviarCodigo =
      "$baseUrl/usuarios/reenviar-codigo";

  static const String productos = "$baseUrl/productos";
  static const String categorias = "$baseUrl/categorias";
  static const String mesas = "$baseUrl/mesas";
  static const String ordenes = "$baseUrl/ordenes";
  static const String traducir = "$baseUrl/traducir";
  static const String favoritos = "$baseUrl/favoritos";
  static const String favoritosVerificar = "$baseUrl/favoritos/verificar";
  static const String resenas = "$baseUrl/resenas";
  static const String inventario = "$baseUrl/inventario";
  static const String notificaciones = "$baseUrl/notificacion";
  static const String chat = "$baseUrl/chat";
  static const String loginGoogle = "$baseUrl/usuarios/login-google";
}