import 'dart:io';

import 'package:davar/locator.dart';
import 'package:davar/src/data/local/database/db.dart';
import 'package:davar/src/data/local/database/db_consts.dart';
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as dart_path;
import 'package:permission_handler/permission_handler.dart';

enum BackupProviderStatus { success, loading, error }

class BackupProvider with ChangeNotifier {
  final DB _localDB = locator<DB>();

  // db directory:
  // Android:
  // /data/user/0/com.example.davar/files/${DbConsts.dbName}.db
  // iOS:

  static const String dbFileName = '${DbConsts.dbName}.db';
  static const String backupFileName = 'davar_backup';
  static const String backupFileExtension = '.db';

  BackupProviderStatus _status = BackupProviderStatus.success;

  BackupProviderStatus get status => _status;

  String _error = '';

  String get error => _error;

  String _info = '';

  String get info => _info;

  Future<String> restoreDatabaseFromFile() async {
    print('BackupProvider restoreDatabaseFromFile');
    String info = 'Restore not tested';
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result == null) return 'restoreDatabaseFromFile - no file!';
      if (!result.isSinglePick) return 'restoreDatabaseFromFile - pick only one file!';
      if (result.files.single.path == null) return 'restoreDatabaseFromFile - file path is bad!';
      // check the file type:
      final String extension = dart_path.extension(result.files.single.path!);
      if (extension != '.db') {
        _error = 'Bad file format!';
        notifyListeners();
        return 'Bad file format!';
      }
      File firstFile = File(result.files.single.path!);
      String res = await _localDB.restoreDatabaseFromFile(firstFile);
      info = 'Successfully Restored - res: $res';
    } catch (e) {
      print('BackupProvider restoreDatabaseFromFile ERROR: $e');
    }
    return info;
  }

  Future<String> makeDatabaseFileCopy() async {
    print('BP makeDatabaseFileCopy');
    try {
      final PermissionStatus status = await Permission.manageExternalStorage.status;
      if (!status.isGranted) await _grantPermissions();
      // second verification for permissions:
      if (await Permission.manageExternalStorage.request().isGranted) {
        final Directory? easyDir = await _tryToGetAndroidUserDirectory('storage/emulated/0/Davar');
        if (easyDir != null) {
          final String path = await _writeDbFile(easyDir);
          _info = 'backup copy saved in this location:\n$path';
          notifyListeners();
          print('DB backup saved in: storage/emulated/0/Davar');
          return path;
        }
        final Directory? dir = await utils.GetDirectory.getUserDirectory();
        if (dir == null) return 'Please check application permissions.';
        final String path = await _writeDbFile(dir);
        print('DB backup saved in this location:\n$path');
        _info = path;
        notifyListeners();
        return path;
      }
    } catch (e) {
      if (kDebugMode) {
        print('BP makeDatabaseFileCopy storage/emulated/0/Davar cannot be created! ERROR: $e');
      }
      _info = 'Directory not created! Please check application permissions';
      notifyListeners();
      return 'Directory not created!';
    }
    return 'Please check application permissions, or your system is not supported!';
  }

  Future<Directory?> _tryToGetAndroidUserDirectory(String path) async {
    final Directory copyTo = Directory('storage/emulated/0/Davar');
    try {
      if (await Permission.manageExternalStorage.request().isGranted) {
        if (await copyTo.exists()) return copyTo;
      } else {
        final bool isPermitted = await _grantPermissions();
        if (isPermitted) {
          Directory newDirectory = await copyTo.create();
          if (await newDirectory.exists()) return newDirectory;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('tryToGetAndroidUserDirectory storage/emulated/0/Davar ERROR: $e');
      }
    }
    return null;
  }

  Future<bool> _grantPermissions() async {
    final PermissionStatus es = await Permission.manageExternalStorage.request();
    final PermissionStatus ml = await Permission.accessMediaLocation.request();
    if (es.isGranted && ml.isGranted) return true;
    return false;
  }

  Future<String> _writeDbFile(Directory location) async {
    final DateTime now = DateTime.now();
    final String iso = now.toIso8601String().split('.').first;
    final String timeStamp = iso.replaceAll(RegExp(r':'), '-');
    try {
      final String? bdPathAndName = await _localDB.getDatabasePathWithFileName();
      // database file path is null
      if (bdPathAndName == null) {
        return 'No permission to get application files!';
      }
      File bdSource = File(bdPathAndName);
      final bool isFile = await bdSource.exists();
      // database file was not found
      if (!isFile) {
        return 'No permission to get application files. File not found!';
      }
      String newPath = '${location.path}/$backupFileName-$timeStamp$backupFileExtension';
      File copy = await bdSource.copy(newPath);
      return copy.path;
    } catch (e) {
      if (kDebugMode) print('writeDbFile(Directory $location): $e');
      return 'Please check application permissions. Backup copy was not saved!';
    }
  }
}
