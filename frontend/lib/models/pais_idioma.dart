
class Idioma {
  final String codigo;
  final String nombre;

  const Idioma({
    required this.codigo,
    required this.nombre,
  });
}

const List<Idioma> idiomasDisponibles = [
  Idioma(codigo: 'es', nombre: 'Español'),
  Idioma(codigo: 'en', nombre: 'English'),
  Idioma(codigo: 'zh', nombre: '中文'),
  Idioma(codigo: 'hi', nombre: 'हिन्दी'),
  Idioma(codigo: 'fr', nombre: 'Français'),
  Idioma(codigo: 'pt', nombre: 'Português'),
  Idioma(codigo: 'de', nombre: 'Deutsch'),
  Idioma(codigo: 'ar', nombre: 'العربية'),
  Idioma(codigo: 'ru', nombre: 'Русский'),
  Idioma(codigo: 'ja', nombre: '日本語'),
  Idioma(codigo: 'ko', nombre: '한국어'),
  Idioma(codigo: 'id', nombre: 'Bahasa Indonesia'),
  Idioma(codigo: 'it', nombre: 'Italiano'),
  Idioma(codigo: 'bn', nombre: 'বাংলা'),
  Idioma(codigo: 'tr', nombre: 'Türkçe'),
];
