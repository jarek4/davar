import 'package:davar/locator.dart';
import 'package:davar/src/domain/i_words_local_db.dart';
import 'package:davar/src/errors_reporter/errors_reporter.dart';
import 'package:sqflite/sqflite.dart';

import 'db.dart';
import 'db_consts.dart';

class WordsDb implements IWordsLocalDb<Map<String, dynamic>> {
  final DB instance = locator<DB>();

  @override

  /// Returns the id of the last inserted row.
  Future<int> createWord(Map<String, dynamic> word) async {
    try {
      final Database db = await instance.database;
      final int newWordId = await db.insert(
        DbConsts.tableWords,
        word,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('DB-createWord - created word: $word');
      return newWordId;
    } on DatabaseException catch (e, stackTrace) {
      await ErrorsReporter.genericThrow(
          e.toString(), Exception('DatabaseException. DB class createWord(word): $word'),
          stackTrace: stackTrace);
      throw Exception('Word was not created. Sorry!');
    } catch (e, stackTrace) {
      await ErrorsReporter.genericThrow(
        e.toString(),
        Exception('Local database-createWord \n word = $word'),
        stackTrace: stackTrace,
      );
      throw Exception('word was not created. Sorry!');
    }
  }

  @override

  /// Returns the number of rows affected.
  Future<int> deleteWord(int id) async {
    try {
      final Database db = await instance.database;
      final int res =
          await db.delete(DbConsts.tableWords, where: '${DbConsts.colId}=?', whereArgs: [id]);
      return res;
    } on DatabaseException catch (e, stackTrace) {
      await ErrorsReporter.genericThrow(
          e.toString(), Exception('DatabaseException. DB class deleteWord. Id = $id'),
          stackTrace: stackTrace);
      throw Exception('Word was not deleted. Sorry!');
    } catch (e) {
      print(e);
      throw Exception('word was not deleted. Sorry!');
    }
  }

  @override

  /// returns the number of changes made.
  Future<int> rawWordUpdate(
      {required List<String> columns, required List values, required int wordId}) async {
    String updateQuery = 'UPDATE ${DbConsts.tableWords}';
    final String set = 'SET ${instance.prepareRawUpdateFilterFromArray(columns)} ';
    const String whereWordId = 'WHERE ${DbConsts.colId} = ?';
    updateQuery = '$updateQuery $set $whereWordId';

    try {
      final Database db = await instance.database;
      final int count = await db.rawUpdate(updateQuery, [...values, wordId]);
      return count;
    } on DatabaseException catch (e, stackTrace) {
      await ErrorsReporter.genericThrow(
          e.toString(),
          Exception(
              'DatabaseException. DB class rawWordUpdate. columns $columns || values = $values'),
          stackTrace: stackTrace);
      throw Exception('Word is not updated. Sorry!');
    } catch (e, stackTrace) {
      await ErrorsReporter.genericThrow(
        e.toString(),
        Exception('DB class rawWordUpdate()'),
        stackTrace: stackTrace,
      );
      throw Exception('word is not updated. Sorry!');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> readAllWords(int userId) async {
    try {
      Database db = await instance.database;
      const String sql = '''
      SELECT
          ${DbConsts.colWCatchword}, 
          ${DbConsts.tableWords}.${DbConsts.colId},
          ${DbConsts.tableWords}.${DbConsts.colWUserId},
          ${DbConsts.colWUserTransl},
          ${DbConsts.colCName} AS ${DbConsts.colWCategory},
          ${DbConsts.colWCategoryId},
          ${DbConsts.colWIsFavorite},
          ${DbConsts.colWIsSentence},
          ${DbConsts.colWPoints},
          ${DbConsts.colWUserLearn},
          ${DbConsts.colWUserNative},
          ${DbConsts.colWClue},
          ${DbConsts.colCreated}
      FROM
          ${DbConsts.tableWords}
      LEFT JOIN ${DbConsts.tableWordCategories} ON
          ${DbConsts.tableWords}.${DbConsts.colWCategoryId} = ${DbConsts.tableWordCategories}.${DbConsts.colId} 
      WHERE
          ${DbConsts.tableWords}.${DbConsts.colWUserId}=?     
      ORDER BY ${DbConsts.tableWords}.${DbConsts.colCreated}''';

      final List<Map<String, dynamic>> resJoin = await db.rawQuery(sql, [userId]);
      return resJoin;
    } on DatabaseException catch (e, stackTrace) {
      await ErrorsReporter.genericThrow(
          e.toString(), Exception('DatabaseException. DB class readAllWords. UserId = $userId'),
          stackTrace: stackTrace);
      throw Exception('Words error!');
    } catch (e) {
      print(e);
      throw Exception('words error!');
    }
  }

  @override
  Future<Map<String, dynamic>> readWord(int id) async {
    try {
      final Database db = await instance.database;
      final List<Map<String, dynamic>> res = await db.query(
        DbConsts.tableWords,
        columns: DbConsts.allWordsColumns,
        where: 'DbConsts.colId = ?',
        whereArgs: [id],
        limit: 1,
      );
      return res.first;
    } on DatabaseException catch (e, stackTrace) {
      await ErrorsReporter.genericThrow(
          e.toString(), Exception('DatabaseException. DB class readWord. Id = $id'),
          stackTrace: stackTrace);
      throw Exception('Word error!');
    } catch (e) {
      print(e);
      throw Exception('word error!');
    }
  }

  @override

  /// returns the number of changes made.
  Future<int> updateWord(Map<String, dynamic> word) async {
    try {
      final Database db = await instance.database;
      final int res =
          await db.update(DbConsts.tableWords, word, conflictAlgorithm: ConflictAlgorithm.replace);
      return res;
    } on DatabaseException catch (e, stackTrace) {
      await ErrorsReporter.genericThrow(
          e.toString(), Exception('DatabaseException. DB class updateWord. Word = $word'),
          stackTrace: stackTrace);
      throw Exception('Word was not updated. Sorry!');
    } catch (e) {
      throw Exception('word was not updated. Sorry!');
    }
  }

  @override

  /// returns Future<List<Map<String, dynamic>>>. <String>query and <List>args cant not be empty!
  Future<List<Map<String, dynamic>>> rawQueryWords(String query, List args) async {
    if (query.isEmpty || args.isEmpty) return [];
    try {
      final Database db = await instance.database;
      final List<Map<String, dynamic>> res = await db.rawQuery(query, args);
      return res;
    } on DatabaseException catch (e, stackTrace) {
      await ErrorsReporter.genericThrow(
          e.toString(), Exception('DatabaseException. DB class rawQueryWords. query = $query'),
          stackTrace: stackTrace);
      throw Exception('Sorry. Words error!');
    } catch (e) {
      throw Exception('Sorry. Words error!');
    }
  }
}
