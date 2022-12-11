import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('bg'),
    const Locale('pl'),
    const Locale('ru'),
    const Locale('tr'),
  ];
  static final allWithFullName = <Map<String, dynamic>>[
    {'locale': const Locale('en'), 'name': 'English'},
    {'locale': const Locale('bg'), 'name': 'български'},
    {'locale': const Locale('pl'), 'name': 'polski'},
    {'locale': const Locale('ru'), 'name': 'Русский'},
    {'locale': const Locale('tr'), 'name': 'Türkçe'},
  ];
}
