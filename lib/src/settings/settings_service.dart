import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  static const String _keyCurrentLocale = 'currentLocale';
  /// Loads the User's preferred ThemeMode from local or remote storage.
  Future<ThemeMode> themeMode() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int themeModeIndex = prefs.getInt('ThemeMode') ?? 0;
      return ThemeMode.values[themeModeIndex];
    } catch (e) {
      if (kDebugMode) print('SettingsService-themeMode E: $e');
    }
    return ThemeMode.system;
  }

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('ThemeMode', theme.index);
    } catch (e) {
      if (kDebugMode) print('SettingsService-updateThemeMode E: $e');
    }
  }
  Future<String?> currentLocale() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyCurrentLocale);
    } catch (e) {
      if (kDebugMode) print('SettingsService-currentLocale E: $e');
    }
    return null;
  }

  Future<void> updateCurrentLocale(String localeCode) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyCurrentLocale, localeCode);
    } catch (e) {
      if (kDebugMode) print('SettingsService-updateCurrentLocale E: $e');
    }
  }

  Future<void> clearLocale() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyCurrentLocale);
    } catch (e) {
      if (kDebugMode) print('SettingsService-clearLocale E: $e');
    }
  }
}
