// ignore_for_file: avoid_print

import 'dart:async';

import 'package:davar/src/errors_reporter/errors_reporter.dart';
import 'package:davar/src/utils/utils.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'db_consts.dart';

class DB {
  static final DB instance = DB._init();
  static Database? _db;

  DB._init();

  Future<Database> get database async {
    if (_db != null) return _db!;
    const String filePath = '${DbConsts.dbName}.db';
    _db = await _initDB(filePath);
    return _db!;
  }

  Future<Database> _initDB(String filePath) async {
    final String dbPath = await getDatabasesPath();
    // dbPath = /data/user/0/com.example.test_two
    final String path = join(dbPath, filePath);
    //  path =  /data/user/0/com.example.test_two/databases/blaa.db
    return await openDatabase(path,
        version: DbConsts.dbVersion,
        onConfigure: _onConfigure,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onOpen: _onOpen);
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
      await db.insert(DbConsts.tableUsers, AppConst.emptyUser.toJson());
      await db.insert(DbConsts.tableWordCategories, DbConsts.commonNoCategory);
    } on DatabaseException catch (e, stackTrace) {
      await ErrorsReporter.genericThrow(e.toString(),
          Exception('Database error. DB class when openDatabase was called - onCreate callback'),
          stackTrace: stackTrace);
      print(e.toString());
      throw Exception('Database can not to be created. Sorry!');
    } on PlatformException catch (err, stackTrace) {
      await ErrorsReporter.genericThrow(
        err.toString(),
        PlatformException(code: err.code, details: 'Sqflite-class DB-_onCreate'),
        stackTrace: stackTrace,
      );
      throw Exception(
          'Same error occurs. Please check whether the application has the required permissions');
    } catch (e) {
      throw Exception('Sorry device settings do not allow the application to be installed');
    }
  }

  _onOpen(Database db) async {
    try {
      print('DB-onOpen. Database name: ${DbConsts.dbName}. Is open - ${db.isOpen}');
    } on DatabaseException catch (e, stackTrace) {
      await ErrorsReporter.genericThrow(e.toString(),
          Exception('Database error. DB class when openDatabase was called - onOpen callback'),
          stackTrace: stackTrace);
      throw Exception('Database can not to be open. Sorry!');
    } on PlatformException catch (err, stackTrace) {
      await ErrorsReporter.genericThrow(
        err.toString(),
        PlatformException(code: err.code, details: 'Sqflite-class DB-_onOpen'),
        stackTrace: stackTrace,
      );
      throw Exception(
          'Same error occurs. Please check whether the application has the required permissions');
    } catch (e) {
      throw Exception('Sorry device settings do not allow the application to be started');
    }
  }

  // UPGRADE DATABASE TABLES
  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    try {
      if (oldVersion < newVersion) {
        // you can execute drop table and create table
        print('DB-onUpgrade. Database name: ${DbConsts.dbName}');
      }
    } on DatabaseException catch (e, stackTrace) {
      await ErrorsReporter.genericThrow(e.toString(),
          Exception('Database error. DB class when openDatabase was called - onUpgrade callback'),
          stackTrace: stackTrace);
      throw Exception('Database upgrade without success. Sorry!');
    } on PlatformException catch (err, stackTrace) {
      await ErrorsReporter.genericThrow(
        err.toString(),
        PlatformException(code: err.code, details: 'Sqflite-class DB-_onUpgrade'),
        stackTrace: stackTrace,
      );
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
      final String filter = prepareRawSelectFilterFromArray(where);
      final List res =
          await db.query(tableName, columns: ['id'], where: '$filter=?', whereArgs: values);
      return res.length;
    } on DatabaseException catch (e, stackTrace) {
      await ErrorsReporter.genericThrow(
          e.toString(),
          Exception(
              'DatabaseException. DB class _queryRowCount(). where = $where || values = $values'),
          stackTrace: stackTrace);
      throw Exception('Same error occurs. Sorry!');
    } catch (_) {
      throw Exception('Same error occurs. Sorry!');
    }
  }

  /// statement = 'id=? AND email=? AND name=?'
  String prepareRawSelectFilterFromArray(List<String> array) {
    // array = ['id', 'email', 'name']; => statement = 'id=? AND email=? AND name=?'
    String statement = '';
    const String append = ' AND ';
    for (int i = 0; i < array.length; i++) {
      final String param = array[i];
      final String temp = '$param = ?';
      if (i < array.length - 1) {
        statement = '$statement$temp$append';
      } else {
        statement = '$statement$temp';
      }
    }
    return statement;
  }

  /// statement = 'name = ?, email = ?'
  String prepareRawUpdateFilterFromArray(List<String> array) {
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
  }
}