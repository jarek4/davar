import 'dart:io';

import 'package:davar/locator.dart';
import 'package:davar/src/data/local/database/db.dart';
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as dart_path;
import 'package:permission_handler/permission_handler.dart';

enum BackupStatus { ready, loading, error }

class BackupProvider with ChangeNotifier {
  final DB _localDB = locator<DB>();

  // db directory:
  // Android:
  // /data/user/0/com.example.davar/files/${DbConsts.dbName}.db
  // or /storage/emulated/0/Android/data/...
  // iOS simulator:
  // /data/Containers/Data/Application/CA..6/Library/Application Support/${DbConsts.dbName}.db

  static const String _backupFileName = 'davar_backup';
  static const String _backupFileExtension = '.db';
  static const String _noPermissionInfo =
      'Please check application permissions, or your device does not support this option.';

  BackupStatus _status = BackupStatus.ready;

  BackupStatus get status => _status;

  String _error = '';

  String get error => _error;

  String _info = '';

  String get info => _info;

  Future<void> restoreDatabaseFromFile() async {
    _handleStatusChange(BackupStatus.loading);
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (!_verifyFile(result)) return;
      File firstFile = File(result!.files.single.path!);
      String res = await _localDB.restoreDatabaseFromFile(firstFile);
      _handleStatusChange(BackupStatus.ready, info: 'Successfully Restored - res: $res');
    } catch (e) {
      if (kDebugMode) print('BP restoreDatabaseFromFile ERROR: $e');
      _handleStatusChange(BackupStatus.error, err: _noPermissionInfo);
    }
  }

  bool _verifyFile(FilePickerResult? result) {
    if (result == null) {
      _handleStatusChange(BackupStatus.ready, info: 'No file selected');
      return false;
    }
    if (!result.isSinglePick) {
      _handleStatusChange(BackupStatus.ready, info: 'Select only one file!');
      return false;
    }
    if (result.files.single.path == null) {
      _handleStatusChange(BackupStatus.ready, info: 'File not found');
      return false;
    }
    // check the file type:
    final String extension = dart_path.extension(result.files.single.path!);
    if (extension != _backupFileExtension) {
      _handleStatusChange(BackupStatus.ready, info: 'Bad file format!');
      return false;
    }
    return true;
  }

  Future<void> makeDatabaseFileCopy() async {
    _handleStatusChange(BackupStatus.loading);
    try {
      // grant permissions
      final PermissionStatus permissionsStatus = await Permission.storage.status;
      if (!permissionsStatus.isGranted) await _grantStoragePermission();

      // get directory to writ the backup file
      final Directory? saveTo = await _getDirectoryToSave();
      if (saveTo == null || !(await saveTo.exists())) {
        // no access to the file system
        _handleStatusChange(BackupStatus.error, err: _noPermissionInfo);
        return;
      }
      // device file system accessible
      final bool isWritten = await _saveBackupToDirectory(saveTo);

      if (!isWritten && !permissionsStatus.isGranted) {
        //permissions not granted!
        _handleStatusChange(BackupStatus.error, err: _noPermissionInfo);
        if (kDebugMode) print('BP makeDatabaseFileCopy permissions not granted!');
      }
    } catch (e) {
      if (kDebugMode) print('BP makeDatabaseFileCopy E: $e');
      _handleStatusChange(BackupStatus.error, err: 'Backup copy not saved');
    }
  }

  Future<bool> _saveBackupToDirectory(Directory saveTo) async {
    try {
      // device file system accessible
      final File? writtenFile = await _writeDbFile(saveTo);
      if (writtenFile == null) {
        // backup copy not saved!
        _handleStatusChange(BackupStatus.error, err: _noPermissionInfo);
        return false;
      } else {
        //saved
        _handleStatusChange(BackupStatus.ready, info: 'Backup location:\n${writtenFile.path}');
      }
    } on FileSystemException catch (e) {
      if (kDebugMode) print('BP makeDatabaseFileCopy FileSystemException: $e');
    } catch (e) {
      if (kDebugMode) print('BP makeDatabaseFileCopy E: $e');
      _handleStatusChange(BackupStatus.error, err: 'Backup copy not saved');
    }
    return true;
  }

  // finds platform specific user accessible directory
  Future<Directory?> _getDirectoryToSave() async {
    try {
      bool isPermitted = await Permission.storage.isGranted;
      if (!isPermitted) {
        isPermitted = await _grantStoragePermission();
      }
      return await utils.GetDirectory.getUserAccessibleDirectory();
    } on FileSystemException catch (e) {
      if (kDebugMode) print('BP getDirectoryToSave FileSystemException: $e');
      return null;
    } catch (e) {
      if (kDebugMode) print('BP getDirectoryToSave ERROR: $e');
      return null;
    }
  }

  Future<bool> _grantStoragePermission() async {
    // iOS Storage is granted
    final PermissionStatus s = await Permission.storage.request();
    if (s.isGranted) return true;
    return false;
  }

  Future<File?> _writeDbFile(Directory location) async {
    final DateTime now = DateTime.now();
    final String iso = now.toIso8601String().split('.').first;
    final String timeStamp = iso.replaceAll(RegExp(r'[:\-T]'), '');
    try {
      final String? bdPathAndName = await _localDB.getDatabasePathWithFileName();
      if (bdPathAndName == null) return null;
      File bdSource = File(bdPathAndName);
      final bool isFile = await bdSource.exists();
      if (!isFile) return null; // database file object not created!
      String newPath = '${location.path}/$_backupFileName-$timeStamp$_backupFileExtension';
      File copy = await bdSource.copy(newPath);
      return copy;
    } on FileSystemException catch (e) {
      if (kDebugMode) print('BP writeDbFile FileSystemException: $e');
      return null;
    } catch (e) {
      if (kDebugMode) print('writeDbFile(Directory $location) E: $e');
      return null;
    }
  }

  void _handleStatusChange(BackupStatus status,
      {bool doNotify = true, String info = '', String err = ''}) {
    _error = err;
    _info = info;
    _status = status;
    if (doNotify) notifyListeners();
  }
}
