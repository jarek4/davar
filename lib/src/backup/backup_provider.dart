import 'dart:io';

import 'package:davar/locator.dart';
import 'package:davar/src/data/local/database/db.dart';
import 'package:davar/src/data/local/database/db_consts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

enum BackupProviderStatus { success, loading, error }

class BackupProvider with ChangeNotifier {
  final DB _localDB = locator<DB>();

  static const String dbFileName = '${DbConsts.dbName}.db';

  Future<String> restoreDatabaseFromFile(File source) async {
    print('BackupProvider restoreDatabaseFromFile');
    String info = 'Restore not tested';
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      await _localDB.restoreDatabaseFromFile(source);
      if (result == null) return 'restoreDatabaseFromFile - no file!';
      if (!result.isSinglePick) return 'restoreDatabaseFromFile - pick only one file!';
      if (result.files.single.path == null) return 'restoreDatabaseFromFile - file path is bad!';
      File firstFile = File(result.files.single.path!);
      String res = await _localDB.restoreDatabaseFromFile(firstFile);
      info = 'Successfully Restored - res: $res';
    } catch (e) {
      print('BackupProvider restoreDatabaseFromFile ERROR: $e');
    }
    return info;
  }

  Future<String> makeDatabaseFileCopy2() async {
    print('BP makeDatabaseFileCopy');
    Directory copyTo = Directory('storage/emulated/0/Davar');
    if (await copyTo.exists()) {
      print('BP makeDatabaseFileCopy Directory exist');
      // Allow access to media only:
      // final PermissionStatus status = await Permission.storage.status;
      //Allow management of all files:
      final PermissionStatus status = await Permission.manageExternalStorage.status;
      // final PermissionStatus status2 = await Permission.accessMediaLocation.status;
      if (!status.isGranted) {
        // await Permission.storage.request();
        await Permission.manageExternalStorage.request();
        await Permission.accessMediaLocation.request();
      }
      // info = 'exists: storage/emulated/0/Davar';
    } else {
      print('BP makeDatabaseFileCopy Directory not exist');
      // info = 'not exists: storage/emulated/0/Davar';
      if (await Permission.manageExternalStorage.request().isGranted) {
        // shows dialog - Allow test_two to access photos and media on your device?
        // Allow or Deny
        // Either the permission was already granted before or the user just granted it.
        Directory newDirectory = await copyTo.create();
        print('BP makeDatabaseFileCopy newDirectory: ${newDirectory.toString()}');

        // Directory documentsDirectory =
        // Directory("storage/emulated/0/Download/");
        // String newPath = join('${documentsDirectory.absolute.path}abcde.db');
        // File a = await source1.copy(newPath);
      } else {
        print('Please give permission');
        // info = 'Please give permission';
      }
    }

    // String newPath = '${copyTo.path}/blaa.db';
    // await source1.copy(newPath);
    // return info;
    return 'test';
  }

  Future<String> makeDatabaseFileCopy() async {
    print('BP makeDatabaseFileCopy');
    try {
      Directory copyTo = Directory('storage/emulated/0/Davar');
      if (await copyTo.exists()) {
        print('BP makeDatabaseFileCopy Directory exist');
        //Allow management of all files:
        final PermissionStatus status = await Permission.manageExternalStorage.status;
        if (!status.isGranted) {
          await Permission.manageExternalStorage.request();
          await Permission.accessMediaLocation.request();
        }
      } else {
        print('BP makeDatabaseFileCopy Directory not exist');
        if (await Permission.manageExternalStorage.request().isGranted) {
          // shows dialog - Allow test_two to access photos and media on your device?
          Directory newDirectory = await copyTo.create();
          print('BP makeDatabaseFileCopy newDirectory: ${newDirectory.toString()}');
          // Directory documentsDirectory =
          // Directory("storage/emulated/0/Download/");
          // String newPath = join('${documentsDirectory.absolute.path}abcde.db');
          // File a = await source1.copy(newPath);
        } else {
          print('Please give permission');
          // info = 'Please give permission';
        }
      }
      final String bdPathAndName = await _localDB.getDatabasePathWithFileName();
      File bdSource = File(bdPathAndName);
      bool e = await bdSource.exists();
      print('BP makeDatabaseFileCopy source1 if exists: $e');

      String newPath = '${copyTo.path}/davar.db';
      File copy = await bdSource.copy(newPath);
      return copy.path;
    } catch (e) {
      print('BP makeDatabaseFileCopy ERROR: $e');
      return 'BP makeDatabaseFileCopy not created!';
    }
    // return info;
  }

  Future<void> checkPermissions() async {
    // info = 'exists: storage/emulated/0/Blaa';
    //Allow management of all files:
    try {
      final PermissionStatus status = await Permission.manageExternalStorage.status;
      print('PermissionStatus status: $status');
      if (!status.isGranted) {
        // await Permission.storage.request();
        await Permission.manageExternalStorage.request();
        await Permission.accessMediaLocation.request();
      } else {
        if (await Permission.manageExternalStorage.request().isGranted) {
          // shows dialog - Allow test_two to access photos and media on your device?
          // Allow or Deny
          // Either the permission was already granted before or the user just granted it.

          // Directory documentsDirectory =
          // Directory("storage/emulated/0/Download/");
          // String newPath = join('${documentsDirectory.absolute.path}abcde.db');
          // File a = await source1.copy(newPath);
        } else {
          print('Please give permission');
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
