import 'package:davar/locator.dart';
import 'package:davar/src/domain/i_word_categories_local_db.dart';
import 'package:davar/src/errors_reporter/errors_reporter.dart';
import 'package:sqflite/sqflite.dart';

import 'db.dart';
import 'db_consts.dart';

class WordCategoriesDb implements IWordCategoriesLocalDb<Map<String, dynamic>> {
  final DB instance = locator<DB>();

  @override
  Future<int> createWordCategory(Map<String, dynamic> category) async {
    final Database db = await instance.database;
    final String name = category['name'];
    try {
      final int nameRecords = await instance.queryRowCount(
          tableName: DbConsts.tableWordCategories, where: [DbConsts.colCName], values: [name]);
      // check if category exists:
      if (nameRecords > 0) return 0;
      // db.insert() returns created category id
      int response = await db.insert(
        DbConsts.tableWordCategories,
        category,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('DB createWordCategory response: $response \n');
      return response;
    } on DatabaseException catch (e, stackTrace) {
      await ErrorsReporter.genericThrow(e.toString(),
          Exception('DatabaseException. DB class createWordCategory. Category = $category'),
          stackTrace: stackTrace);
      throw Exception('Category was not created. Sorry!');
    } catch (e) {
      throw Exception('category was not created. Sorry!');
    }
  }

  @override
  Future<int> deleteWordCategory(int id) async {
    try {
      final Database db = await instance.database;
      final int res = await db
          .delete(DbConsts.tableWordCategories, where: '${DbConsts.colId} = ?', whereArgs: [id]);
      return res;
    } on DatabaseException catch (e, stackTrace) {
      await ErrorsReporter.genericThrow(
          e.toString(), Exception('DatabaseException. DB class deleteWordCategory. id = $id'),
          stackTrace: stackTrace);
      throw Exception('Category was not deleted. Sorry!');
    } catch (e) {
      print(e);
      throw Exception('category was not deleted. Sorry!');
    }
  }

  @override

  /// returns  list of categories belongs to the user
  Future<List<Map<String, dynamic>>> readAllWordCategory(int userId) async {
    // fetch DbConsts.commonNoCategory [id: 1, name: 'no-category']; id should be an int!
    int noCategoryId = _parseToIntOr1(DbConsts.commonNoCategory[DbConsts.colId]);
    try {
      final Database db = await instance.database;
      final List<Map<String, dynamic>> res = await db.query(
        DbConsts.tableWordCategories,
        columns: DbConsts.allWordCategoriesColumns,
        where: '${DbConsts.colCUserId} = ? OR ${DbConsts.colId} = ?',
        whereArgs: [userId, noCategoryId],
        orderBy: '${DbConsts.colId} DESC',
      );
      return res;
    } on DatabaseException catch (e, stackTrace) {
      await ErrorsReporter.genericThrow(e.toString(),
          Exception('DatabaseException. DB class readAllWordCategory. UserId = $userId'),
          stackTrace: stackTrace);
      throw Exception('Category error!');
    } catch (e) {
      print(e);
      throw Exception('category error!');
    }
  }

  int _parseToIntOr1(dynamic val) {
    if (val == null) return 1;
    if (val is int) return val.abs();
    if (val is double) return val.round().abs();
    final int parsed = int.tryParse(DbConsts.commonNoCategory[DbConsts.colId]) ?? 1;
    return parsed;
  }

  @override

  /// returns single category
  Future<Map<String, dynamic>?> readWordCategory(int id) async {
    try {
      final Database db = await instance.database;
      final List<Map<String, dynamic>> res = await db.query(
        DbConsts.tableWordCategories,
        columns: DbConsts.allWordCategoriesColumns,
        where: '${DbConsts.colId} = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (res.isEmpty) return null;
      return res.first;
    } on DatabaseException catch (e, stackTrace) {
      await ErrorsReporter.genericThrow(
          e.toString(), Exception('DatabaseException. DB class readWordCategory. Id = $id'),
          stackTrace: stackTrace);
      throw Exception('Category error!');
    } catch (e) {
      print(e);
      throw Exception('category error!');
    }
  }

  @override

  /// Returns the number of changes made
  Future<int> updateWordCategory(Map<String, dynamic> category) async {
    try {
      final Database db = await instance.database;
      final int res = await db.update(DbConsts.tableWordCategories, category,
          conflictAlgorithm: ConflictAlgorithm.replace);
      return res;
    } on DatabaseException catch (e, stackTrace) {
      await ErrorsReporter.genericThrow(e.toString(),
          Exception('DatabaseException. DB class updateWordCategory. Category = $category'),
          stackTrace: stackTrace);
      throw Exception('Category was not updated. Sorry!');
    } catch (e) {
      throw Exception('category was not updated. Sorry!');
    }
  }
}
