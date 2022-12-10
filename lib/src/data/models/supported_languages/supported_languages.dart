
/*
use a country code, for example:
USA: us, Great Britain: gbr, Bulgaria: bg
English - en, eng
 */

import 'davar_language.dart';

class SupportedLanguages {
  static const List<DavarLanguage> list = [
    DavarLanguage(name: 'English', englishName: 'English', shortcut: 'en'), // en, US, USA, GB, GBR
    DavarLanguage(name: 'български', englishName: 'Bulgarian', shortcut: 'bg'),// bg, BG, BGR
    DavarLanguage(name: 'Русский', englishName: 'Russian', shortcut: 'ru'), // ru, RU, RUS
    DavarLanguage(name: 'polski', englishName: 'Polish', shortcut: 'pl'), // pl, PL, POL
    DavarLanguage(name: 'Türkçe', englishName: 'Turkish', shortcut: 'tr'), // tr, TR, TUR
    DavarLanguage(name: 'other', englishName: 'other', shortcut: 'en'),
  ];
  static final List<String> englishNames = list.map((e) => e.englishName).toList();
  static final List<String> names = list.map((e) => e.name).toList();
  static final List<String> shortcuts = list.map((e) => e.shortcut).toList();
}