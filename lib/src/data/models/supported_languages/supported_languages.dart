/*
use a country code, for example:
USA: us, Great Britain: gbr, Bulgaria: bg
English - en, eng
 */

import 'davar_language.dart';

class SupportedLanguages {
  /// not for localizations
  static const List<DavarLanguage> list = [
    DavarLanguage(name: 'English', englishName: 'English', shortcut: 'en'),
    DavarLanguage(name: 'български', englishName: 'Bulgarian', shortcut: 'bg'),
    DavarLanguage(name: 'Русский', englishName: 'Russian', shortcut: 'ru'),
    DavarLanguage(name: 'polski', englishName: 'Polish', shortcut: 'pl'),
    DavarLanguage(name: 'Türkçe', englishName: 'Turkish', shortcut: 'tr'),
    DavarLanguage(name: 'other', englishName: 'other', shortcut: 'en'),
  ];

  /// use for localizations
  static const List<DavarLanguage> localize = [
    DavarLanguage(name: 'English', englishName: 'English', shortcut: 'en'), // en, US, USA, GB, GBR
    DavarLanguage(name: 'български', englishName: 'Bulgarian', shortcut: 'bg'), // bg, BG, BGR
    DavarLanguage(name: 'Русский', englishName: 'Russian', shortcut: 'ru'), // ru, RU, RUS
    DavarLanguage(name: 'polski', englishName: 'Polish', shortcut: 'pl'), // pl, PL, POL
    DavarLanguage(name: 'Türkçe', englishName: 'Turkish', shortcut: 'tr'), // tr, TR, TUR
    DavarLanguage(name: 'system', englishName: 'system', shortcut: 'system'),
  ];

  static final List<String> englishNames = list.map((e) => e.englishName).toList();
  static final List<String> names = list.map((e) => e.name).toList();
  static final List<String> shortcuts = list.map((e) => e.shortcut).toList();

  static final List<String> localizeEnglishNames = localize.map((e) => e.englishName).toList();
  static final List<String> localizeNames = localize.map((e) => e.name).toList();
  static final List<String> localizeShortcuts = localize.map((e) => e.shortcut).toList();

  static String codeToLanguage(String code) {
    switch (code) {
      case 'bg':
        return 'български';
      case 'pl':
        return 'polski';
      case 'ru':
        return 'Русский';
      case 'tr':
        return 'Türkçe';
      case 'system':
        return 'system';
      default:
        return 'English';
    }
  }

  static String languageToCode(String code) {
    switch (code) {
      case 'български':
        return 'bg';
      case 'polski':
        return 'pl';
      case 'Русский':
        return 'ru';
      case 'Türkçe':
        return 'tr';
      case 'system':
        return 'system';
      default:
        return 'en';
    }
  }
}
