import 'dart:async';
import 'dart:io';

import 'package:davar/src/errors_reporter/errors_reporter.dart';
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/foundation.dart';
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
        onUpgrade: _onUpgrade);
  }

  Future<String> _getPath() async {
    final String? path = await utils.GetDirectory.getDbPath();
    if (path != null) return path;
    final String dbPath = await getDatabasesPath();
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
      await db.insert(DbConsts.tableUsers, utils.AppConst.emptyUser.toJson());
      // test account for Play Console tests:
      await db.insert(DbConsts.tableUsers, {
        'name': 'TestUser',
        'id': 2,
        'email': 'test4@example.com',
        'createdAt': '0000:00:00',
        'learning': 'learning',
        'native': 'native',
        'password': '4Aa1z4444vB',
        'authToken': '4authToken'
      });
      // create common category [no category] in word_categories table
      await db.insert(DbConsts.tableWordCategories, DbConsts.commonNoCategory);
    } on DatabaseException catch (e) {
      await ErrorsReporter.genericThrow(e.toString(),
          Exception('Database error. DB class when openDatabase was called - onCreate callback'));
      throw Exception('Database can not to be created. Sorry!');
    } on PlatformException catch (err) {
      await ErrorsReporter.genericThrow(
          err.toString(), PlatformException(code: err.code, details: 'Sqflite-class DB-_onCreate'));
      throw Exception('Same error occurs. Please check application required permissions');
    } catch (e) {
      throw Exception('Sorry device settings do not allow the application to be installed');
    }
  }

  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    try {
      if (oldVersion < newVersion) {
        if (kDebugMode) print('DB-onUpgrade. Database name: ${DbConsts.dbName}');
      }
    } on DatabaseException catch (e) {
      await ErrorsReporter.genericThrow(e.toString(),
          Exception('Database error. DB class when openDatabase was called - onUpgrade callback'));
      throw Exception('Database upgrade without success. Sorry!');
    } on PlatformException catch (err) {
      await ErrorsReporter.genericThrow(err.toString(),
          PlatformException(code: err.code, details: 'Sqflite-class DB-_onUpgrade'));
      throw Exception('Same error occurs. Please check application required permissions');
    } catch (e) {
      throw Exception('Sorry device settings do not allow performing this operation');
    }
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
      if (kDebugMode) print('DB-getDatabasePathWithFileName ERROR: $e');
      return null;
    }
  }
}
