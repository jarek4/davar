import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart' as pp;

class GetDirectory {
  /// Android and iOS location
  static Future<String?> getDbPath() async {
    final Directory? sd = await _getAppSupportDirectory();
    // final String? sd = await _getAppSupportDirectory();
    //print('GetDirectory DB PATH sd: $sd');
    if (sd != null) return sd.path;
    final Directory? ad = await _getAppDocumentsDirectory();
    // final String? ad = await _getAppDocumentsDirectory();
    //print('GetDirectory DB PATH ad: $ad');
    return ad?.path;
  }

  /// Android and iOS location
  static Future<Directory?> getUserAccessibleDirectory() async {
    Directory? d1 = await _getAppDocumentsDirectory();
    print('GetDirectory AppDocumentsDirectory: ${d1?.path}');
    Directory? d2 = await _getAppSupportDirectory();
    print('GetDirectory AppSupportDirectory: ${d2?.path}');
    Directory? dir;
    try {
      if (Platform.isIOS) {
        Directory? d = await _getAppDocumentsDirectory();
        if (d != null) {
          return dir = d;
        }
        return dir = await _getAppSupportDirectory();
      }
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
      print('_getAppSupportDirectory: ${d.path}');
      return d;
    } on pp.MissingPlatformDirectoryException catch (e) {
      if (kDebugMode) {
        print(
            'GetDbDirectory getAppSupportDirectory MissingPlatformDirectory: $e');
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('GetDbDirectory getAppSupportDirectory E: $e');
      }
      return null;
    }
  }

  // directory for the app to store files that only it can access.
  // Android - AppData; iOS - NSDocumentDirectory.
  static Future<Directory?> _getAppDocumentsDirectory() async {
    try {
      Directory d = await pp.getApplicationDocumentsDirectory();
      print('GetDirectory AppDocumentsDirectory: ${d.path}');
      if (await d.exists()) return d;
      return d;
    } on pp.MissingPlatformDirectoryException catch (e) {
      if (kDebugMode) {
        print(
            'GetDbDirectory getAppDocumentsDirectory MissingPlatformDirectory: $e');
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('GetDbDirectory getAppDocumentsDirectory E: $e');
      }
      return null;
    }
  }
  // static Future<Directory?> externalStorageDir() async {
  //   try {
  //     Directory? d = await pp.getExternalStorageDirectory();
  //     print('GetDirectory AppDocumentsDirectory: ${d?.path}'.substring(0, 45));
  //     if (d != null && await d.exists()) return d;
  //     return d;
  //   } on pp.MissingPlatformDirectoryException catch (e) {
  //     if (kDebugMode) {
  //       print(
  //           'GetDbDirectory getAppDocumentsDirectory MissingPlatformDirectory: $e');
  //     }
  //     return null;
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('GetDbDirectory getAppDocumentsDirectory E: $e');
  //     }
  //     return null;
  //   }
  // }
}
