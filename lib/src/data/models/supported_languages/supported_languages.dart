
/*
use a country code, for example:
USA: us, Great Britain: gbr, Bulgaria: bg
Romani: rom rmn; English - en, eng
 */

import 'davar_language.dart';

class SupportedLanguages {
  static const List<DavarLanguage> list = [
    DavarLanguage(name: 'English', englishName: 'English', shortcut: 'us'),
    DavarLanguage(name: 'български', englishName: 'Bulgarian', shortcut: 'bg'),
    DavarLanguage(name: 'романи', englishName: 'Romani', shortcut: 'rom'),
    DavarLanguage(name: 'Türkçe', englishName: 'Turkish', shortcut: 'tr'),
  ];
  static final List<String> englishNames = list.map((e) => e.englishName).toList();
  static final List<String> names = list.map((e) => e.name).toList();
  static final List<String> shortcuts = list.map((e) => e.shortcut).toList();
}