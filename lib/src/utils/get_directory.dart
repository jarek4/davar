import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart' as pp;

class GetDirectory {
  static Future<String?> getDbPath() async {
    final String? sd = await _getAppSupportDirectory();
    if (sd != null) return sd;
    final String? ad = await _getAppDocumentsDirectory();
    return ad;
  }
  static Future<Directory?> getUserDirectory() async {
    if (Platform.isAndroid) {
     final Directory? forUser = await pp.getExternalStorageDirectory();
     if(forUser == null) return null;
     return forUser;
    } else if (Platform.isIOS) {
      return null;
    }
    return null;
  }

  static Future<String?> _getAppSupportDirectory() async {
    try {
      Directory d = await pp.getApplicationSupportDirectory();
      // Android: /data/user/0/com.example.davar/files
      if (await d.exists()) return d.path;
      return d.path;
    } on pp.MissingPlatformDirectoryException catch (e) {
      if (kDebugMode) {
        print('GetDbDirectory getAppSupportDirectory MissingPlatformDirectory: $e');
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('GetDbDirectory getAppSupportDirectory MissingPlatformDirectory: $e');
      }
      return null;
    }
  }

  static Future<String?> _getAppDocumentsDirectory() async {
    try {
      Directory d = await pp.getApplicationDocumentsDirectory();
      print('GetDirectory AppDocumentsDirectory: ${d.path}');
      if (await d.exists()) return d.path;
      return d.path;
    } on pp.MissingPlatformDirectoryException catch (e) {
      if (kDebugMode) {
        print('GetDbDirectory getAppDocumentsDirectory MissingPlatformDirectory: $e');
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('GetDbDirectory getAppDocumentsDirectory MissingPlatformDirectory: $e');
      }
      return null;
    }
  }
}
