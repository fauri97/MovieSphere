class LanguageUtils {
  static String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'Inglês';
      case 'pt':
        return 'Português';
      case 'es':
        return 'Espanhol';
      case 'fr':
        return 'Francês';
      case 'de':
        return 'Alemão';
      case 'it':
        return 'Italiano';
      case 'ja':
        return 'Japonês';
      case 'ko':
        return 'Coreano';
      case 'ru':
        return 'Russo';
      case 'zh':
        return 'Chinês';
      case 'ar':
        return 'Árabe';
      case 'hi':
        return 'Hindi';
      case 'id':
        return 'Indonésio';
      case 'nl':
        return 'Holandês';
      case 'pl':
        return 'Polonês';
      case 'sv':
        return 'Sueco';
      case 'tr':
        return 'Turco';
      case 'ps':
        return 'Pastó';
      case 'mn':
        return 'Mongol';
      case 'fa':
        return 'Persa';
      case 'wo':
        return 'Uolofe / Wolof';
      case 'th':
        return 'Tailandês';
      default:
        return 'Desconhecido';
    }
  }
}
