class PaisIdioma {
  final String pais;
  final String bandera;
  final String idiomaCodigo;
  final String idiomaNombre;

  const PaisIdioma({
    required this.pais,
    required this.bandera,
    required this.idiomaCodigo,
    required this.idiomaNombre,
  });
}

const List<PaisIdioma> paisesDisponibles = [
  // ===== AMÉRICA DEL NORTE =====
  PaisIdioma(pais: 'Canadá', bandera: '🇨🇦', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Estados Unidos', bandera: '🇺🇸', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'México', bandera: '🇲🇽', idiomaCodigo: 'es', idiomaNombre: 'Español'),

  // ===== AMÉRICA CENTRAL =====
  PaisIdioma(pais: 'Guatemala', bandera: '🇬🇹', idiomaCodigo: 'es', idiomaNombre: 'Español'),
  PaisIdioma(pais: 'Belice', bandera: '🇧🇿', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Honduras', bandera: '🇭🇳', idiomaCodigo: 'es', idiomaNombre: 'Español'),
  PaisIdioma(pais: 'El Salvador', bandera: '🇸🇻', idiomaCodigo: 'es', idiomaNombre: 'Español'),
  PaisIdioma(pais: 'Nicaragua', bandera: '🇳🇮', idiomaCodigo: 'es', idiomaNombre: 'Español'),
  PaisIdioma(pais: 'Costa Rica', bandera: '🇨🇷', idiomaCodigo: 'es', idiomaNombre: 'Español'),
  PaisIdioma(pais: 'Panamá', bandera: '🇵🇦', idiomaCodigo: 'es', idiomaNombre: 'Español'),

  // ===== CARIBE =====
  PaisIdioma(pais: 'Cuba', bandera: '🇨🇺', idiomaCodigo: 'es', idiomaNombre: 'Español'),
  PaisIdioma(pais: 'Haití', bandera: '🇭🇹', idiomaCodigo: 'fr', idiomaNombre: 'Français'),
  PaisIdioma(pais: 'República Dominicana', bandera: '🇩🇴', idiomaCodigo: 'es', idiomaNombre: 'Español'),
  PaisIdioma(pais: 'Jamaica', bandera: '🇯🇲', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Bahamas', bandera: '🇧🇸', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Trinidad y Tobago', bandera: '🇹🇹', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Barbados', bandera: '🇧🇧', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Santa Lucía', bandera: '🇱🇨', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Granada', bandera: '🇬🇩', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'San Vicente y las Granadinas', bandera: '🇻🇨', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Antigua y Barbuda', bandera: '🇦🇬', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Dominica', bandera: '🇩🇲', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'San Cristóbal y Nieves', bandera: '🇰🇳', idiomaCodigo: 'en', idiomaNombre: 'English'),

  // ===== AMÉRICA DEL SUR =====
  PaisIdioma(pais: 'Colombia', bandera: '🇨🇴', idiomaCodigo: 'es', idiomaNombre: 'Español'),
  PaisIdioma(pais: 'Venezuela', bandera: '🇻🇪', idiomaCodigo: 'es', idiomaNombre: 'Español'),
  PaisIdioma(pais: 'Guyana', bandera: '🇬🇾', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Surinam', bandera: '🇸🇷', idiomaCodigo: 'nl', idiomaNombre: 'Nederlands'),
  PaisIdioma(pais: 'Ecuador', bandera: '🇪🇨', idiomaCodigo: 'es', idiomaNombre: 'Español'),
  PaisIdioma(pais: 'Perú', bandera: '🇵🇪', idiomaCodigo: 'es', idiomaNombre: 'Español'),
  PaisIdioma(pais: 'Brasil', bandera: '🇧🇷', idiomaCodigo: 'pt', idiomaNombre: 'Português'),
  PaisIdioma(pais: 'Bolivia', bandera: '🇧🇴', idiomaCodigo: 'es', idiomaNombre: 'Español'),
  PaisIdioma(pais: 'Paraguay', bandera: '🇵🇾', idiomaCodigo: 'es', idiomaNombre: 'Español'),
  PaisIdioma(pais: 'Chile', bandera: '🇨🇱', idiomaCodigo: 'es', idiomaNombre: 'Español'),
  PaisIdioma(pais: 'Argentina', bandera: '🇦🇷', idiomaCodigo: 'es', idiomaNombre: 'Español'),
  PaisIdioma(pais: 'Uruguay', bandera: '🇺🇾', idiomaCodigo: 'es', idiomaNombre: 'Español'),

  // ===== EUROPA OCCIDENTAL =====
  PaisIdioma(pais: 'Francia', bandera: '🇫🇷', idiomaCodigo: 'fr', idiomaNombre: 'Français'),
  PaisIdioma(pais: 'Alemania', bandera: '🇩🇪', idiomaCodigo: 'de', idiomaNombre: 'Deutsch'),
  PaisIdioma(pais: 'Países Bajos', bandera: '🇳🇱', idiomaCodigo: 'nl', idiomaNombre: 'Nederlands'),
  PaisIdioma(pais: 'Bélgica', bandera: '🇧🇪', idiomaCodigo: 'fr', idiomaNombre: 'Français'),
  PaisIdioma(pais: 'Luxemburgo', bandera: '🇱🇺', idiomaCodigo: 'fr', idiomaNombre: 'Français'),
  PaisIdioma(pais: 'Suiza', bandera: '🇨🇭', idiomaCodigo: 'de', idiomaNombre: 'Deutsch'),
  PaisIdioma(pais: 'Austria', bandera: '🇦🇹', idiomaCodigo: 'de', idiomaNombre: 'Deutsch'),
  PaisIdioma(pais: 'Liechtenstein', bandera: '🇱🇮', idiomaCodigo: 'de', idiomaNombre: 'Deutsch'),
  PaisIdioma(pais: 'Mónaco', bandera: '🇲🇨', idiomaCodigo: 'fr', idiomaNombre: 'Français'),

  // ===== EUROPA DEL SUR =====
  PaisIdioma(pais: 'España', bandera: '🇪🇸', idiomaCodigo: 'es', idiomaNombre: 'Español'),
  PaisIdioma(pais: 'Portugal', bandera: '🇵🇹', idiomaCodigo: 'pt', idiomaNombre: 'Português'),
  PaisIdioma(pais: 'Italia', bandera: '🇮🇹', idiomaCodigo: 'it', idiomaNombre: 'Italiano'),
  PaisIdioma(pais: 'Grecia', bandera: '🇬🇷', idiomaCodigo: 'el', idiomaNombre: 'Ελληνικά'),
  PaisIdioma(pais: 'Malta', bandera: '🇲🇹', idiomaCodigo: 'mt', idiomaNombre: 'Malti'),
  PaisIdioma(pais: 'San Marino', bandera: '🇸🇲', idiomaCodigo: 'it', idiomaNombre: 'Italiano'),
  PaisIdioma(pais: 'Ciudad del Vaticano', bandera: '🇻🇦', idiomaCodigo: 'it', idiomaNombre: 'Italiano'),
  PaisIdioma(pais: 'Andorra', bandera: '🇦🇩', idiomaCodigo: 'ca', idiomaNombre: 'Català'),
  PaisIdioma(pais: 'Chipre', bandera: '🇨🇾', idiomaCodigo: 'el', idiomaNombre: 'Ελληνικά'),

  // ===== EUROPA DEL NORTE =====
  PaisIdioma(pais: 'Reino Unido', bandera: '🇬🇧', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Irlanda', bandera: '🇮🇪', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Islandia', bandera: '🇮🇸', idiomaCodigo: 'is', idiomaNombre: 'Íslenska'),
  PaisIdioma(pais: 'Noruega', bandera: '🇳🇴', idiomaCodigo: 'no', idiomaNombre: 'Norsk'),
  PaisIdioma(pais: 'Suecia', bandera: '🇸🇪', idiomaCodigo: 'sv', idiomaNombre: 'Svenska'),
  PaisIdioma(pais: 'Dinamarca', bandera: '🇩🇰', idiomaCodigo: 'da', idiomaNombre: 'Dansk'),
  PaisIdioma(pais: 'Finlandia', bandera: '🇫🇮', idiomaCodigo: 'fi', idiomaNombre: 'Suomi'),
  PaisIdioma(pais: 'Estonia', bandera: '🇪🇪', idiomaCodigo: 'et', idiomaNombre: 'Eesti'),
  PaisIdioma(pais: 'Letonia', bandera: '🇱🇻', idiomaCodigo: 'lv', idiomaNombre: 'Latviešu'),
  PaisIdioma(pais: 'Lituania', bandera: '🇱🇹', idiomaCodigo: 'lt', idiomaNombre: 'Lietuvių'),

  // ===== EUROPA DEL ESTE =====
  PaisIdioma(pais: 'Rusia', bandera: '🇷🇺', idiomaCodigo: 'ru', idiomaNombre: 'Русский'),
  PaisIdioma(pais: 'Ucrania', bandera: '🇺🇦', idiomaCodigo: 'uk', idiomaNombre: 'Українська'),
  PaisIdioma(pais: 'Bielorrusia', bandera: '🇧🇾', idiomaCodigo: 'be', idiomaNombre: 'Беларуская'),
  PaisIdioma(pais: 'Polonia', bandera: '🇵🇱', idiomaCodigo: 'pl', idiomaNombre: 'Polski'),
  PaisIdioma(pais: 'República Checa', bandera: '🇨🇿', idiomaCodigo: 'cs', idiomaNombre: 'Čeština'),
  PaisIdioma(pais: 'Eslovaquia', bandera: '🇸🇰', idiomaCodigo: 'sk', idiomaNombre: 'Slovenčina'),
  PaisIdioma(pais: 'Hungría', bandera: '🇭🇺', idiomaCodigo: 'hu', idiomaNombre: 'Magyar'),
  PaisIdioma(pais: 'Rumania', bandera: '🇷🇴', idiomaCodigo: 'ro', idiomaNombre: 'Română'),
  PaisIdioma(pais: 'Moldavia', bandera: '🇲🇩', idiomaCodigo: 'ro', idiomaNombre: 'Română'),

  // ===== BALCANES =====
  PaisIdioma(pais: 'Croacia', bandera: '🇭🇷', idiomaCodigo: 'hr', idiomaNombre: 'Hrvatski'),
  PaisIdioma(pais: 'Eslovenia', bandera: '🇸🇮', idiomaCodigo: 'sl', idiomaNombre: 'Slovenščina'),
  PaisIdioma(pais: 'Bosnia y Herzegovina', bandera: '🇧🇦', idiomaCodigo: 'bs', idiomaNombre: 'Bosanski'),
  PaisIdioma(pais: 'Serbia', bandera: '🇷🇸', idiomaCodigo: 'sr', idiomaNombre: 'Српски'),
  PaisIdioma(pais: 'Montenegro', bandera: '🇲🇪', idiomaCodigo: 'sr', idiomaNombre: 'Crnogorski'),
  PaisIdioma(pais: 'Macedonia del Norte', bandera: '🇲🇰', idiomaCodigo: 'mk', idiomaNombre: 'Македонски'),
  PaisIdioma(pais: 'Albania', bandera: '🇦🇱', idiomaCodigo: 'sq', idiomaNombre: 'Shqip'),
  PaisIdioma(pais: 'Kosovo', bandera: '🇽🇰', idiomaCodigo: 'sq', idiomaNombre: 'Shqip'),
  PaisIdioma(pais: 'Bulgaria', bandera: '🇧🇬', idiomaCodigo: 'bg', idiomaNombre: 'Български'),

  // ===== ASIA ORIENTAL =====
  PaisIdioma(pais: 'China', bandera: '🇨🇳', idiomaCodigo: 'zh', idiomaNombre: '中文'),
  PaisIdioma(pais: 'Japón', bandera: '🇯🇵', idiomaCodigo: 'ja', idiomaNombre: '日本語'),
  PaisIdioma(pais: 'Corea del Sur', bandera: '🇰🇷', idiomaCodigo: 'ko', idiomaNombre: '한국어'),
  PaisIdioma(pais: 'Corea del Norte', bandera: '🇰🇵', idiomaCodigo: 'ko', idiomaNombre: '한국어'),
  PaisIdioma(pais: 'Mongolia', bandera: '🇲🇳', idiomaCodigo: 'mn', idiomaNombre: 'Монгол'),
  PaisIdioma(pais: 'Taiwán', bandera: '🇹🇼', idiomaCodigo: 'zh', idiomaNombre: '中文'),

  // ===== ASIA SUDORIENTAL =====
  PaisIdioma(pais: 'Vietnam', bandera: '🇻🇳', idiomaCodigo: 'vi', idiomaNombre: 'Tiếng Việt'),
  PaisIdioma(pais: 'Tailandia', bandera: '🇹🇭', idiomaCodigo: 'th', idiomaNombre: 'ไทย'),
  PaisIdioma(pais: 'Indonesia', bandera: '🇮🇩', idiomaCodigo: 'id', idiomaNombre: 'Bahasa Indonesia'),
  PaisIdioma(pais: 'Filipinas', bandera: '🇵🇭', idiomaCodigo: 'tl', idiomaNombre: 'Filipino'),
  PaisIdioma(pais: 'Malasia', bandera: '🇲🇾', idiomaCodigo: 'ms', idiomaNombre: 'Bahasa Melayu'),
  PaisIdioma(pais: 'Singapur', bandera: '🇸🇬', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Myanmar', bandera: '🇲🇲', idiomaCodigo: 'my', idiomaNombre: 'မြန်မာ'),
  PaisIdioma(pais: 'Camboya', bandera: '🇰🇭', idiomaCodigo: 'km', idiomaNombre: 'ខ្មែរ'),
  PaisIdioma(pais: 'Laos', bandera: '🇱🇦', idiomaCodigo: 'lo', idiomaNombre: 'ລາວ'),
  PaisIdioma(pais: 'Brunéi', bandera: '🇧🇳', idiomaCodigo: 'ms', idiomaNombre: 'Bahasa Melayu'),
  PaisIdioma(pais: 'Timor Oriental', bandera: '🇹🇱', idiomaCodigo: 'pt', idiomaNombre: 'Português'),

  // ===== ASIA MERIDIONAL =====
  PaisIdioma(pais: 'India', bandera: '🇮🇳', idiomaCodigo: 'hi', idiomaNombre: 'हिन्दी'),
  PaisIdioma(pais: 'Pakistán', bandera: '🇵🇰', idiomaCodigo: 'ur', idiomaNombre: 'اردو'),
  PaisIdioma(pais: 'Bangladés', bandera: '🇧🇩', idiomaCodigo: 'bn', idiomaNombre: 'বাংলা'),
  PaisIdioma(pais: 'Sri Lanka', bandera: '🇱🇰', idiomaCodigo: 'si', idiomaNombre: 'සිංහල'),
  PaisIdioma(pais: 'Nepal', bandera: '🇳🇵', idiomaCodigo: 'ne', idiomaNombre: 'नेपाली'),
  PaisIdioma(pais: 'Bután', bandera: '🇧🇹', idiomaCodigo: 'dz', idiomaNombre: 'Dzongkha'),
  PaisIdioma(pais: 'Maldivas', bandera: '🇲🇻', idiomaCodigo: 'dv', idiomaNombre: 'Dhivehi'),
  PaisIdioma(pais: 'Afganistán', bandera: '🇦🇫', idiomaCodigo: 'ps', idiomaNombre: 'پښتو'),

  // ===== ASIA CENTRAL =====
  PaisIdioma(pais: 'Kazajistán', bandera: '🇰🇿', idiomaCodigo: 'kk', idiomaNombre: 'Қазақ'),
  PaisIdioma(pais: 'Uzbekistán', bandera: '🇺🇿', idiomaCodigo: 'uz', idiomaNombre: 'Oʻzbek'),
  PaisIdioma(pais: 'Turkmenistán', bandera: '🇹🇲', idiomaCodigo: 'tk', idiomaNombre: 'Türkmen'),
  PaisIdioma(pais: 'Kirguistán', bandera: '🇰🇬', idiomaCodigo: 'ky', idiomaNombre: 'Кыргызча'),
  PaisIdioma(pais: 'Tayikistán', bandera: '🇹🇯', idiomaCodigo: 'tg', idiomaNombre: 'Тоҷикӣ'),

  // ===== MEDIO ORIENTE =====
  PaisIdioma(pais: 'Arabia Saudita', bandera: '🇸🇦', idiomaCodigo: 'ar', idiomaNombre: 'العربية'),
  PaisIdioma(pais: 'Emiratos Árabes Unidos', bandera: '🇦🇪', idiomaCodigo: 'ar', idiomaNombre: 'العربية'),
  PaisIdioma(pais: 'Catar', bandera: '🇶🇦', idiomaCodigo: 'ar', idiomaNombre: 'العربية'),
  PaisIdioma(pais: 'Kuwait', bandera: '🇰🇼', idiomaCodigo: 'ar', idiomaNombre: 'العربية'),
  PaisIdioma(pais: 'Baréin', bandera: '🇧🇭', idiomaCodigo: 'ar', idiomaNombre: 'العربية'),
  PaisIdioma(pais: 'Omán', bandera: '🇴🇲', idiomaCodigo: 'ar', idiomaNombre: 'العربية'),
  PaisIdioma(pais: 'Yemen', bandera: '🇾🇪', idiomaCodigo: 'ar', idiomaNombre: 'العربية'),
  PaisIdioma(pais: 'Irak', bandera: '🇮🇶', idiomaCodigo: 'ar', idiomaNombre: 'العربية'),
  PaisIdioma(pais: 'Irán', bandera: '🇮🇷', idiomaCodigo: 'fa', idiomaNombre: 'فارسی'),
  PaisIdioma(pais: 'Israel', bandera: '🇮🇱', idiomaCodigo: 'he', idiomaNombre: 'עברית'),
  PaisIdioma(pais: 'Jordania', bandera: '🇯🇴', idiomaCodigo: 'ar', idiomaNombre: 'العربية'),
  PaisIdioma(pais: 'Líbano', bandera: '🇱🇧', idiomaCodigo: 'ar', idiomaNombre: 'العربية'),
  PaisIdioma(pais: 'Siria', bandera: '🇸🇾', idiomaCodigo: 'ar', idiomaNombre: 'العربية'),
  PaisIdioma(pais: 'Turquía', bandera: '🇹🇷', idiomaCodigo: 'tr', idiomaNombre: 'Türkçe'),
  PaisIdioma(pais: 'Georgia', bandera: '🇬🇪', idiomaCodigo: 'ka', idiomaNombre: 'ქართული'),
  PaisIdioma(pais: 'Armenia', bandera: '🇦🇲', idiomaCodigo: 'hy', idiomaNombre: 'Հայերեն'),
  PaisIdioma(pais: 'Azerbaiyán', bandera: '🇦🇿', idiomaCodigo: 'az', idiomaNombre: 'Azərbaycan'),

  // ===== ÁFRICA DEL NORTE =====
  PaisIdioma(pais: 'Egipto', bandera: '🇪🇬', idiomaCodigo: 'ar', idiomaNombre: 'العربية'),
  PaisIdioma(pais: 'Libia', bandera: '🇱🇾', idiomaCodigo: 'ar', idiomaNombre: 'العربية'),
  PaisIdioma(pais: 'Túnez', bandera: '🇹🇳', idiomaCodigo: 'ar', idiomaNombre: 'العربية'),
  PaisIdioma(pais: 'Argelia', bandera: '🇩🇿', idiomaCodigo: 'ar', idiomaNombre: 'العربية'),
  PaisIdioma(pais: 'Marruecos', bandera: '🇲🇦', idiomaCodigo: 'ar', idiomaNombre: 'العربية'),
  PaisIdioma(pais: 'Sudán', bandera: '🇸🇩', idiomaCodigo: 'ar', idiomaNombre: 'العربية'),

  // ===== ÁFRICA OCCIDENTAL =====
  PaisIdioma(pais: 'Nigeria', bandera: '🇳🇬', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Ghana', bandera: '🇬🇭', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Senegal', bandera: '🇸🇳', idiomaCodigo: 'fr', idiomaNombre: 'Français'),
  PaisIdioma(pais: 'Malí', bandera: '🇲🇱', idiomaCodigo: 'fr', idiomaNombre: 'Français'),
  PaisIdioma(pais: 'Costa de Marfil', bandera: '🇨🇮', idiomaCodigo: 'fr', idiomaNombre: 'Français'),
  PaisIdioma(pais: 'Guinea', bandera: '🇬🇳', idiomaCodigo: 'fr', idiomaNombre: 'Français'),
  PaisIdioma(pais: 'Benín', bandera: '🇧🇯', idiomaCodigo: 'fr', idiomaNombre: 'Français'),
  PaisIdioma(pais: 'Togo', bandera: '🇹🇬', idiomaCodigo: 'fr', idiomaNombre: 'Français'),
  PaisIdioma(pais: 'Sierra Leona', bandera: '🇸🇱', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Liberia', bandera: '🇱🇷', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Burkina Faso', bandera: '🇧🇫', idiomaCodigo: 'fr', idiomaNombre: 'Français'),
  PaisIdioma(pais: 'Níger', bandera: '🇳🇪', idiomaCodigo: 'fr', idiomaNombre: 'Français'),
  PaisIdioma(pais: 'Gambia', bandera: '🇬🇲', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Guinea-Bisáu', bandera: '🇬🇼', idiomaCodigo: 'pt', idiomaNombre: 'Português'),
  PaisIdioma(pais: 'Cabo Verde', bandera: '🇨🇻', idiomaCodigo: 'pt', idiomaNombre: 'Português'),
  PaisIdioma(pais: 'Mauritania', bandera: '🇲🇷', idiomaCodigo: 'ar', idiomaNombre: 'العربية'),

  // ===== ÁFRICA CENTRAL =====
  PaisIdioma(pais: 'Camerún', bandera: '🇨🇲', idiomaCodigo: 'fr', idiomaNombre: 'Français'),
  PaisIdioma(pais: 'Chad', bandera: '🇹🇩', idiomaCodigo: 'fr', idiomaNombre: 'Français'),
  PaisIdioma(pais: 'República Democrática del Congo', bandera: '🇨🇩', idiomaCodigo: 'fr', idiomaNombre: 'Français'),
  PaisIdioma(pais: 'República del Congo', bandera: '🇨🇬', idiomaCodigo: 'fr', idiomaNombre: 'Français'),
  PaisIdioma(pais: 'Gabón', bandera: '🇬🇦', idiomaCodigo: 'fr', idiomaNombre: 'Français'),
  PaisIdioma(pais: 'República Centroafricana', bandera: '🇨🇫', idiomaCodigo: 'fr', idiomaNombre: 'Français'),
  PaisIdioma(pais: 'Guinea Ecuatorial', bandera: '🇬🇶', idiomaCodigo: 'es', idiomaNombre: 'Español'),
  PaisIdioma(pais: 'Santo Tomé y Príncipe', bandera: '🇸🇹', idiomaCodigo: 'pt', idiomaNombre: 'Português'),

  // ===== ÁFRICA ORIENTAL =====
  PaisIdioma(pais: 'Kenia', bandera: '🇰🇪', idiomaCodigo: 'sw', idiomaNombre: 'Kiswahili'),
  PaisIdioma(pais: 'Tanzania', bandera: '🇹🇿', idiomaCodigo: 'sw', idiomaNombre: 'Kiswahili'),
  PaisIdioma(pais: 'Uganda', bandera: '🇺🇬', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Etiopía', bandera: '🇪🇹', idiomaCodigo: 'am', idiomaNombre: 'አማርኛ'),
  PaisIdioma(pais: 'Somalia', bandera: '🇸🇴', idiomaCodigo: 'so', idiomaNombre: 'Af-Soomaali'),
  PaisIdioma(pais: 'Ruanda', bandera: '🇷🇼', idiomaCodigo: 'fr', idiomaNombre: 'Français'),
  PaisIdioma(pais: 'Burundi', bandera: '🇧🇮', idiomaCodigo: 'fr', idiomaNombre: 'Français'),
  PaisIdioma(pais: 'Sudán del Sur', bandera: '🇸🇸', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Eritrea', bandera: '🇪🇷', idiomaCodigo: 'ar', idiomaNombre: 'العربية'),
  PaisIdioma(pais: 'Yibuti', bandera: '🇩🇯', idiomaCodigo: 'fr', idiomaNombre: 'Français'),
  PaisIdioma(pais: 'Madagascar', bandera: '🇲🇬', idiomaCodigo: 'mg', idiomaNombre: 'Malagasy'),
  PaisIdioma(pais: 'Mauricio', bandera: '🇲🇺', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Seychelles', bandera: '🇸🇨', idiomaCodigo: 'fr', idiomaNombre: 'Français'),
  PaisIdioma(pais: 'Comoras', bandera: '🇰🇲', idiomaCodigo: 'fr', idiomaNombre: 'Français'),

  // ===== ÁFRICA AUSTRAL =====
  PaisIdioma(pais: 'Sudáfrica', bandera: '🇿🇦', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Zimbabue', bandera: '🇿🇼', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Zambia', bandera: '🇿🇲', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Mozambique', bandera: '🇲🇿', idiomaCodigo: 'pt', idiomaNombre: 'Português'),
  PaisIdioma(pais: 'Botsuana', bandera: '🇧🇼', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Namibia', bandera: '🇳🇦', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Angola', bandera: '🇦🇴', idiomaCodigo: 'pt', idiomaNombre: 'Português'),
  PaisIdioma(pais: 'Malaui', bandera: '🇲🇼', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Lesoto', bandera: '🇱🇸', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Esuatini', bandera: '🇸🇿', idiomaCodigo: 'en', idiomaNombre: 'English'),

  // ===== OCEANÍA =====
  PaisIdioma(pais: 'Australia', bandera: '🇦🇺', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Nueva Zelanda', bandera: '🇳🇿', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Papúa Nueva Guinea', bandera: '🇵🇬', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Fiyi', bandera: '🇫🇯', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Islas Salomón', bandera: '🇸🇧', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Vanuatu', bandera: '🇻🇺', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Samoa', bandera: '🇼🇸', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Kiribati', bandera: '🇰🇮', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Tonga', bandera: '🇹🇴', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Micronesia', bandera: '🇫🇲', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Palaos', bandera: '🇵🇼', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Islas Marshall', bandera: '🇲🇭', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Nauru', bandera: '🇳🇷', idiomaCodigo: 'en', idiomaNombre: 'English'),
  PaisIdioma(pais: 'Tuvalu', bandera: '🇹🇻', idiomaCodigo: 'en', idiomaNombre: 'English'),
];