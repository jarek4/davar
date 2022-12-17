import 'package:davar/locator.dart';
import 'package:davar/src/data/local/database/db.dart';
import 'package:davar/src/domain/i_user_local_db.dart';
import 'package:davar/src/errors_reporter/errors_reporter.dart';
import 'package:sqflite/sqflite.dart';

import 'db_consts.dart';

class AuthDb implements IUserLocalDb<Map<String, dynamic>> {
  final DB instance = locator<DB>();

  @override

  /// returns created user id, or -1 if email is taken, 0 if conflict
  Future<int> createUser(Map<String, dynamic> newUser) async {
    final String email = newUser['email'];
    // check if user with given email already exists in database
    final bool isTaken = await _checkIsEmailTaken(email);
    if (isTaken) return -1;
    try {
      final Database db = await instance.database;
      final int newUserId = await db.insert(
        DbConsts.tableUsers,
        newUser,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return newUserId;
    } on DatabaseException catch (e, stackTrace) {
      await ErrorsReporter.genericThrow(
          e.toString(), Exception('DatabaseException. DB class createUser(newUser): $newUser'),
          stackTrace: stackTrace);
      throw Exception('We can not create the user. Sorry!');
    } catch (e, stackTrace) {
      await ErrorsReporter.genericThrow(
        e.toString(),
        Exception('Local database-createUser \n newUser = $newUser'),
        stackTrace: stackTrace,
      );
      throw Exception('We can not create the user. Sorry!');
    }
  }

  @override
  Future<int> deleteUser(int userId) async {
    try {
      final Database db = await instance.database;
      final int deletedRecords =
          await db.delete(DbConsts.tableUsers, where: 'id = ?', whereArgs: [userId]);
      return deletedRecords;
    } on DatabaseException catch (e, stackTrace) {
      await ErrorsReporter.genericThrow(
          e.toString(), Exception('DatabaseException. DB class deleteUser(userId), id = $userId'),
          stackTrace: stackTrace);
      throw Exception('User is not deleted. Sorry!');
    } catch (e, stackTrace) {
      await ErrorsReporter.genericThrow(
        e.toString(),
        Exception('Local database-deleteUser id= $userId'),
        stackTrace: stackTrace,
      );
      throw Exception('User is not deleted. Sorry!');
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
    final String set =
        'SET ${instance.prepareRawComaFilterFromArray(DbConsts.tableUsers, columns)} ';
    const String where = 'WHERE ${DbConsts.colId} = ?';
    updateQuery = '$updateQuery $set $where';

    try {
      final Database db = await instance.database;
      final int count = await db.rawUpdate(updateQuery, [...values, id]);
      return count;
    } on DatabaseException catch (e, stackTrace) {
      await ErrorsReporter.genericThrow(
          e.toString(),
          Exception(
              'DatabaseException. DB class rawUpdateUser. columns $columns || values = $values'),
          stackTrace: stackTrace);
      throw Exception('User is not updated. Sorry!');
    } catch (e, stackTrace) {
      await ErrorsReporter.genericThrow(
        e.toString(),
        Exception('DB class rawUpdateUser()'),
        stackTrace: stackTrace,
      );
      throw Exception('User is not updated. Sorry!');
    }
  }

  /// Returns the number of changes made
  @override
  Future<int> updateUser(Map<String, dynamic> u, int userId) async {
    try {
      final Database db = await instance.database;
      final int res = await db
          .update(DbConsts.tableUsers, u, where: '${DbConsts.colId} = ?', whereArgs: [userId]);
      return res;
    } on DatabaseException catch (e, stackTrace) {
      await ErrorsReporter.genericThrow(e.toString(),
          Exception('DatabaseException. DB class updateUser. userId $userId || values = $u'),
          stackTrace: stackTrace);
      throw Exception('User is not updated. Sorry!');
    } catch (e, stackTrace) {
      await ErrorsReporter.genericThrow(
        e.toString(),
        Exception('DB class rawUpdateUser()'),
        stackTrace: stackTrace,
      );
      throw Exception('User is not updated. Sorry!');
    }
  }

  @override

  /// returns List of records as List<Map<String, dynamic>?>
  Future<List<Map<String, dynamic>?>> selectUser({
    required List<String> where,
    required List values,
  }) async {
    try {
      final Database db = await instance.database;
      final String filter = instance.prepareRawAndFilterFromArray(DbConsts.tableUsers, where);
      final List<Map<String, dynamic>?> res =
          await db.query(DbConsts.tableUsers, where: filter, whereArgs: values);
      return res;
    } on DatabaseException catch (e, stackTrace) {
      await ErrorsReporter.genericThrow(e.toString(),
          Exception('DatabaseException. DB class selectUser(): where = $where || values = $values'),
          stackTrace: stackTrace);
      throw Exception('User not found. Sorry!');
    } catch (e, stackTrace) {
      await ErrorsReporter.genericThrow(
        e.toString(),
        Exception('DB class selectUser()'),
        stackTrace: stackTrace,
      );
      throw Exception('User not found. Sorry!');
    }
  }

  Future<bool> _checkIsEmailTaken(String email) async {
    try {
      final int rowCount = await instance.queryRowCount(
          tableName: DbConsts.tableUsers, where: [DbConsts.colUEmail], values: [email]);
      return rowCount > 0;
    } catch (e) {
      rethrow;
    }
  }
}
