// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:davar/src/errors_reporter/errors_reporter.dart';
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/services.dart';
import 'package:path/path.dart' as dart_path;
import 'package:sqflite/sqflite.dart';

import 'db_consts.dart';

class DB {
  static final DB instance = DB._init();
  static Database? _db;

  DB._init();

  Future<Database> get database async {
    if (_db != null) return _db!;
    const String dbFileName = '${DbConsts.dbName}.db'; // davar_database.db
    _db = await _initDB(dbFileName);
    return _db!;
  }

  // iOS: path_provider is recommended to get the databases directory.
  Future<Database> _initDB(String filePath) async {
     final String dbPath = await _getPath();
    final String path = dart_path.join(dbPath, filePath);
    return await openDatabase(path,
        version: DbConsts.dbVersion,
        onConfigure: _onConfigure,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onOpen: _onOpen);
  }

  Future<String> _getPath() async {
   final String? path = await utils.GetDirectory.getDbPath();
   print('DB path: $path');
   if(path != null) return path;
   final String dbPath = await getDatabasesPath();
   print('DB path: $dbPath');
   // Android: /data/user/0/com.example.davar/files
   // iOS: /data/Containers/Data/Application/CA..6/Library/Application Support/davar_database.db
   return dbPath;
  }

  _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _onCreate(Database db, int ver) async {
    try {
      await db.execute(DbConsts.createUsersTableStatement);
      await db.execute(DbConsts.createWordsTableStatement);
      await db.execute(DbConsts.createWordCategoriesTableStatement);
      // create common category [no category] in word_categories table
      await db.insert(DbConsts.tableUsers, utils.AppConst.emptyUser.toJson());
      await db.insert(DbConsts.tableWordCategories, DbConsts.commonNoCategory);
    } on DatabaseException catch (e) {
      await ErrorsReporter.genericThrow(e.toString(),
          Exception('Database error. DB class when openDatabase was called - onCreate callback'));
      print(e.toString());
      throw Exception('Database can not to be created. Sorry!');
    } on PlatformException catch (err) {
      await ErrorsReporter.genericThrow(
          err.toString(), PlatformException(code: err.code, details: 'Sqflite-class DB-_onCreate'));
      throw Exception(
          'Same error occurs. Please check whether the application has the required permissions');
    } catch (e) {
      throw Exception('Sorry device settings do not allow the application to be installed');
    }
  }

  _onOpen(Database db) async {
    try {
      print('DB-onOpen. Database name: ${DbConsts.dbName}');
    } on DatabaseException catch (e) {
      await ErrorsReporter.genericThrow(e.toString(),
          Exception('Database error. DB class when openDatabase was called - onOpen callback'));
      throw Exception('Database can not to be open. Sorry!');
    } on PlatformException catch (err) {
      await ErrorsReporter.genericThrow(
          err.toString(), PlatformException(code: err.code, details: 'Sqflite-class DB-_onOpen'));
      throw Exception(
          'Same error occurs. Please check whether the application has the required permissions');
    } catch (e) {
      throw Exception('Sorry device settings do not allow the application to be started');
    }
  }

  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    try {
      if (oldVersion < newVersion) {
        print('DB-onUpgrade. Database name: ${DbConsts.dbName}');
      }
    } on DatabaseException catch (e) {
      await ErrorsReporter.genericThrow(e.toString(),
          Exception('Database error. DB class when openDatabase was called - onUpgrade callback'));
      throw Exception('Database upgrade without success. Sorry!');
    } on PlatformException catch (err) {
      await ErrorsReporter.genericThrow(err.toString(),
          PlatformException(code: err.code, details: 'Sqflite-class DB-_onUpgrade'));
      throw Exception(
          'Same error occurs. Please check whether the application has the required permissions');
    } catch (e) {
      throw Exception('Sorry device settings do not allow performing this operation');
    }
  }

  Future<String> getVersion() async {
    final Database db = await instance.database;
    final int currentVersion = await db.getVersion();
    return currentVersion.toString();
  }

  Future<int> queryRowCount(
      {required String tableName,
      required List<String> where,
      required List<dynamic> values}) async {
    try {
      final Database db = await instance.database;
      final String filter = prepareRawAndFilterFromArray(tableName, where);
      final List res =
          await db.query(tableName, columns: ['id'], where: '$filter=?', whereArgs: values);
      return res.length;
    } on DatabaseException catch (e) {
      await ErrorsReporter.genericThrow(
          e.toString(),
          Exception(
              'DatabaseException. DB class _queryRowCount(). Where= $where; Values= $values'));
      throw Exception('Database exception. Sorry!');
    } catch (_) {
      throw Exception('Database error. Sorry!');
    }
  }

  /// statement = 'tableName.id=? AND tableName.email=? AND tableName.name=?'
  String prepareRawAndFilterFromArray(String tableName, List<String> array) {
    // array = ['id', 'email', 'name']; => statement = 'id=? AND email=? AND name=?'
    String statement = '';
    const String append = ' AND ';
    for (int i = 0; i < array.length; i++) {
      final String param = array[i];
      final String temp = '$tableName.$param =?';
      if (i < array.length - 1) {
        statement = '$statement$temp$append';
      } else {
        statement = '$statement$temp';
      }
    }
    return statement;
  }

  /// statement = 'tableName.name=?, tableName.email=?'
  String prepareRawComaFilterFromArray(String tableName, List<String> array) {
    // array = ['email', 'name']; => statement = 'name = ?, email = ?'
    String statement = '';
    const String append = ', ';
    for (int i = 0; i < array.length; i++) {
      String param = array[i];
      // String temp = '$tableName.$param =?';
      String temp = '$param =?';
      if (i < array.length - 1) {
        statement = '$statement$temp$append';
      } else {
        statement = '$statement$temp';
      }
    }
    return statement;
  }

  Future<bool> databaseExists(String path) => databaseFactory.databaseExists(path);

  Future<String> restoreDatabaseFromFile(File source) async {
    const String dbFileName = '${DbConsts.dbName}.db';
    final String dbPath = await _getPath();
    final String path = dart_path.join(dbPath, dbFileName);
    print('DB-restoreDatabaseFromFile(File:  ${source.path})');
    // source.path :
    // /storage/emulated/0/Android/data/com.example.davar/files/Davar/davar.db
    try {
      File copied = await source.copy(path);
      final String copiedPath = copied.path;
      return copiedPath;
    } on DatabaseException catch (e) {
      await ErrorsReporter.genericThrow(
          e.toString(),
          Exception(
              'DatabaseException. DB class restoreDatabaseFromFile(source.path: ${source.path})'));
      throw Exception('It is not possible to copy file: ${source.path} to database');
    } on FormatException catch (e) {
      await ErrorsReporter.genericThrow(
          e.toString(),
          Exception(
              'FormatException. DB class restoreDatabaseFromFile(source.path: ${source.path})'));
      throw Exception('The file: ${source.path} is a bad format');
    } catch (e) {
      print(e);
      return 'not restored';
    }
  }

  Future<String?> getDatabasePathWithFileName() async {
    try {
      const String dbFileName = '${DbConsts.dbName}.db';
      final String dbPath = await _getPath();
      final String path = dart_path.join(dbPath, dbFileName);
      return path;
    } catch (e) {
      print('DB-getDatabasePathWithFileName ERROR: $e');
      return null;
    }
  }

/* /// statement = 'name = ?, email = ?'
  String prepareRawLikeFilterFromArray(List<String> array, List<dynamic> args) {
    // array = ['email', 'name']; => statement = 'name = ?, email = ?'
    String statement = '';
    const String append = ', ';
    for (int i = 0; i < array.length; i++) {
      String param = array[i];
      String temp = '$param = ?';
      if (i < array.length - 1) {
        statement = '$statement$temp$append';
      } else {
        statement = '$statement$temp';
      }
    }
    return statement;
  }*/
}
