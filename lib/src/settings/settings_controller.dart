import 'package:davar/locator.dart';
import 'package:flutter/material.dart';

import 'settings_service.dart';

class SettingsController with ChangeNotifier {
  final SettingsService _settingsService = locator<SettingsService>();

  late ThemeMode _themeMode;
  String? _localeCode;

  ThemeMode get themeMode => _themeMode;

  String? get localeCode => _localeCode;

  /// Load the user's settings from the SettingsService.
  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    _localeCode = await _settingsService.currentLocale();
    notifyListeners();
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;
    if (newThemeMode == _themeMode) return;
    _themeMode = newThemeMode;
    notifyListeners();
    await _settingsService.updateThemeMode(newThemeMode);
  }

  Future<void> updateLocale(String? localeCode) async {
    _localeCode = localeCode;
    notifyListeners();
    if (localeCode == null) {
      await _settingsService.clearLocale();
    } else {
      await _settingsService.updateCurrentLocale(localeCode);
    }
  }
}
