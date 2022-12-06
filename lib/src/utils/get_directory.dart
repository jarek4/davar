import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart' as pp;

class GetDirectory {
  /// Android and iOS location
  static Future<String?> getDbPath() async {
    final Directory? sd = await _getAppSupportDirectory();
    // final String? sd = await _getAppSupportDirectory();
    if (sd != null) return sd.path;
    final Directory? ad = await _getAppDocumentsDirectory();
    // final String? ad = await _getAppDocumentsDirectory();
    return ad?.path;
  }

  /// Android and iOS location
  static Future<Directory?> getUserAccessibleDirectory() async {
    Directory? dir;
    try {
      if (Platform.isIOS) return dir = await _getAppDocumentsDirectory();
      if (Platform.isAndroid) {
        final Directory? forUser = await pp.getExternalStorageDirectory();
        if (forUser != null) return dir = forUser;
        dir = await _getAppDocumentsDirectory();
      }
    } catch (e) {
      if (kDebugMode) print('GetDbDirectory getUserDirectory E: $e');
    }
    return dir;
  }

  static Future<Directory?> _getAppSupportDirectory() async {
    try {
      Directory d = await pp.getApplicationSupportDirectory();
      // Android: /data/user/0/com.example.davar/files
      if (await d.exists()) return d;
      return d;
    } on pp.MissingPlatformDirectoryException catch (e) {
      if (kDebugMode) {
        print('GetDbDirectory getAppSupportDirectory MissingPlatformDirectory: $e');
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('GetDbDirectory getAppSupportDirectory E: $e');
      }
      return null;
    }
  }

  static Future<Directory?> _getAppDocumentsDirectory() async {
    try {
      Directory d = await pp.getApplicationDocumentsDirectory();
      print('GetDirectory AppDocumentsDirectory: ${d.path}');
      if (await d.exists()) return d;
      return d;
    } on pp.MissingPlatformDirectoryException catch (e) {
      if (kDebugMode) {
        print('GetDbDirectory getAppDocumentsDirectory MissingPlatformDirectory: $e');
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('GetDbDirectory getAppDocumentsDirectory E: $e');
      }
      return null;
    }
  }
}
