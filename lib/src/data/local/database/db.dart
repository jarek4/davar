import 'dart:async';

import 'package:davar/src/data/local/database/db_consts.dart';
import 'package:davar/src/domain/i_user_local_db.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB implements IUserLocalDb<Map<String, dynamic>> {
  static final DB instance = DB._init();
  static Database? _db;

  DB._init();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB(DbConsts.name);
    return _db!;
  }

  Future<Database> _initDB(String filePath) async {
    final String dbPath = await getDatabasesPath();
    // dbPath = /data/user/0/com.example.test_two
    final String path = join(dbPath, filePath);
    //  path =  /data/user/0/com.example.test_two/databases/blaa.db
    return await openDatabase(path,
        version: DbConsts.version, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future _onCreate(Database db, int ver) async {
    // await db.execute(DbConsts.createWordsTableStatement);
    await db.execute(DbConsts.createUsersTableStatement);
  }

  // UPGRADE DATABASE TABLES
  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      // you can execute drop table and create table
      // 'SELECT sqlite_version();' int currentVersion
      await db.getVersion();
    }
  }

  Future<String> getVersion() async {
    final Database db = await instance.database;
    int currentVersion = await db.getVersion();
    return currentVersion.toString();
  }

  @override
  Future<int> createUser(Map<String, dynamic> newUser) async {
    final String email = newUser['email'];
    print('DB-createUser-email: $email');
    // check if user with given email already exists in database
    bool isTaken = await _checkIsEmailTaken(email);
    print('DB-createUser-isTaken: $isTaken');
    if (isTaken) return -1;
    try {
      final Database db = await instance.database;
      int newUserId = await db.insert(
        DbConsts.tableUsers,
        newUser,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('DB-createUser-newUserId: $newUserId');
      return newUserId;
    } catch (e) {
      String msg = 'Local database-createUser:\n$e';
      throw Exception(msg);
    }
  }

  @override
  Future<int> deleteUser(int userId) async {
    try {
      Database db = await instance.database;
      int deletedRecords = await db
          .delete(DbConsts.tableUsers, where: 'id=?', whereArgs: [userId]);
      return deletedRecords;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  /// returns List of records as List<Map<String, dynamic>>
  Future<List<Map<String, dynamic>>> select({
    required List<String> where,
    required List values,
  }) async {
    try {
      Database db = await instance.database;
      String filter = _prepareRawSelectFilterFromArray(where);
      List<Map<String, dynamic>> res =
          await db.query(DbConsts.tableUsers, where: filter, whereArgs: values);
      return res;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<int> rawUpdateUser({
    required List<String> columns,
    required List<dynamic> values,
    required int id,
  }) async {
    // database.rawUpdate('UPDATE Test SET name = ?, value = ? WHERE name = ?', ['updated name', '9876', 'some name']);
    // spaces at the ends are important!
    String updateQuery = 'UPDATE ${DbConsts.tableUsers}';
    final String set = 'SET ${_prepareRawUpdateFilterFromArray(columns)} ';
    const String where = 'WHERE ${DbConsts.colId}=? ';
    updateQuery = '$updateQuery $set $where';

    try {
      Database db = await instance.database;
      final int count = await db.rawUpdate(updateQuery, [...values, id]);
      return count;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<int> _queryRowCount(List<String> where, List<dynamic> values) async {
    Database db = await instance.database;
    String filter = _prepareRawSelectFilterFromArray(where);
    List res = await db.query(DbConsts.tableUsers,
        columns: ['id'], where: filter, whereArgs: values);
    return res.length;
  }

  String _prepareRawSelectFilterFromArray(List<String> array) {
    // array = ['id', 'email', 'name']; => statement = 'name=? AND last_name=? AND year=?'
    String statement = '';
    String append = ' AND ';

    for (int i = 0; i < array.length; i++) {
      String param = array[i];
      String temp = '$param=?';
      if (i < array.length - 1) {
        statement = '$statement$temp$append';
      } else {
        statement = '$statement$temp';
      }
    }
    return statement;
  }

  String _prepareRawUpdateFilterFromArray(List<String> array) {
    // array = ['id', 'email', 'name']; => statement = 'name=? and last_name=? and year=?'
    String statement = '';
    String append = ', ';

    for (int i = 0; i < array.length; i++) {
      String param = array[i];
      String temp = '$param=?';
      if (i < array.length - 1) {
        statement = '$statement$temp$append';
      } else {
        statement = '$statement$temp';
      }
    }
    return statement;
  }

  Future<bool> _checkIsEmailTaken(String email) async {
    final bool isEmailTaken =
        await _queryRowCount([DbConsts.colUEmail], [email]) > 0;
    if (isEmailTaken) {
      throw Exception('User with this email: $email already exists');
    }
    return isEmailTaken;
  }
}
