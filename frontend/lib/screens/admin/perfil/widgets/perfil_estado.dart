part of '../../admin_perfil_screen.dart';

mixin _PerfilEstado on State<AdminPerfilScreen> {
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();

  final _passwordActualController = TextEditingController();
  final _nuevaPasswordController = TextEditingController();
  final _confirmarPasswordController = TextEditingController();

  Map<String, dynamic>? _usuario;
  bool _cargando = true;
  bool _guardando = false;
  bool _cerrandoSesion = false;
  bool _mostrarFormularioEdicion = false;
  bool _mostrarFormularioPassword = false;
  bool _ocultarPasswordActual = true;
  bool _ocultarNuevaPassword = true;
  bool _ocultarConfirmacion = true;

  File? _imagenSeleccionada;
}