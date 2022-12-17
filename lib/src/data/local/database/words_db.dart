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
      return newWordId;
    } on DatabaseException catch (e) {
      await ErrorsReporter.genericThrow(
          e.toString(), Exception('DatabaseException. DB class createWord(word): $word'));
      throw Exception('Word was not created');
    } on FormatException catch (e) {
      await ErrorsReporter.genericThrow(
          e.toString(), Exception('FormatException. DB class createWord. Word = $word,'));
      throw Exception('Word was not created, bad format.');
    } catch (e) {
      await ErrorsReporter.genericThrow(
          e.toString(), Exception('Local database-createWord \n word = $word'));
      throw Exception('word was not created.');
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
    } on DatabaseException catch (e) {
      await ErrorsReporter.genericThrow(
          e.toString(), Exception('DatabaseException. DB class deleteWord. Id = $id'));
      throw Exception('Word was not deleted.');
    } catch (e) {
      await ErrorsReporter.genericThrow(e.toString(), Exception('DB class deleteWord. Id = $id'));
      throw Exception('word was not deleted.');
    }
  }

  @override

  /// returns the number of changes made.
  Future<int> rawWordUpdate(
      {required List<String> columns, required List values, required int wordId}) async {
    String updateQuery = 'UPDATE ${DbConsts.tableWords}';
    final String set =
        'SET ${instance.prepareRawComaFilterFromArray(DbConsts.tableWords, columns)}';
    const String whereWordId = 'WHERE ${DbConsts.colId} =?';
    updateQuery = '$updateQuery $set $whereWordId';
    try {
      final Database db = await instance.database;
      final int count = await db.rawUpdate(updateQuery, [...values, wordId]);
      return count;
    } on DatabaseException catch (e) {
      await ErrorsReporter.genericThrow(
          e.toString(),
          Exception(
              'DatabaseException. DB class rawWordUpdate. columns $columns || values = $values'));
      throw Exception('Word is not updated.');
    } on FormatException catch (e) {
      await ErrorsReporter.genericThrow(
          e.toString(),
          Exception(
              'FormatException. DB class rawWordUpdate. id = $wordId, columns $columns || values = $values'));
      throw Exception('Word is not updated, bad format.');
    } catch (e) {
      await ErrorsReporter.genericThrow(e.toString(), Exception('DB class rawWordUpdate()'));
      throw Exception('word is not updated.');
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
      ORDER BY ${DbConsts.tableWords}.${DbConsts.colCreated} DESC''';

      final List<Map<String, dynamic>> resJoin = await db.rawQuery(sql, [userId]);
      return resJoin;
    } on DatabaseException catch (e) {
      await ErrorsReporter.genericThrow(
          e.toString(), Exception('DatabaseException. DB class readAllWords. UserId = $userId'));
      throw Exception('Can not load your words!');
    } on FormatException catch (e) {
      await ErrorsReporter.genericThrow(
          e.toString(), Exception('FormatException. DB class readAllWords. UserId = $userId.'));
      throw Exception('Can not load words, bad format.');
    } catch (e) {
      throw Exception('Cannot load your words.');
    }
  }

  @override
  Future<Map<String, dynamic>> readWord(int id) async {
    try {
      final Database db = await instance.database;
      final List<Map<String, dynamic>> res = await db.query(
        DbConsts.tableWords,
        columns: DbConsts.allWordsColumns,
        where: '${DbConsts.colId} =?',
        whereArgs: [id],
        limit: 1,
      );
      return res.first;
    } on DatabaseException catch (e) {
      await ErrorsReporter.genericThrow(
          e.toString(), Exception('DatabaseException. DB class readWord. Id = $id'));
      throw Exception('Can not read the word!');
    } on FormatException catch (e) {
      await ErrorsReporter.genericThrow(
          e.toString(), Exception('FormatException. DB class readWord. UserId = $id.'));
      throw Exception('Can not load the word, bad format.');
    } catch (e) {
      throw Exception('Cannot read the word!');
    }
  }

  @override

  /// returns the number of changes made.
  Future<int> updateWord(Map<String, dynamic> word) async {
    final int? id = word[DbConsts.colId];
    if (id == null || id < 1) return 0;
    try {
      final Database db = await instance.database;
      final int res = await db.update(DbConsts.tableWords, word,
          where: '${DbConsts.colId} =?',
          whereArgs: [id],
          conflictAlgorithm: ConflictAlgorithm.replace);
      return res;
    } on DatabaseException catch (e) {
      await ErrorsReporter.genericThrow(
          e.toString(), Exception('DatabaseException. DB class updateWord. Word = $word'));
      throw Exception('Word was not updated.');
    } on FormatException catch (e) {
      await ErrorsReporter.genericThrow(
          e.toString(), Exception('FormatException. DB class updateWord. Word = $word.'));
      throw Exception('Can not update, bad format.');
    } catch (e) {
      throw Exception('word was not updated.');
    }
  }

  @override

  /// returns Future<List<Map<String, dynamic>>>. <String>query and <List>args cannot be empty!
  Future<List<Map<String, dynamic>>> rawQueryWords(String query, List args) async {
    if (query.isEmpty || args.isEmpty) return [];
    try {
      final Database db = await instance.database;
      final List<Map<String, dynamic>> res = await db.rawQuery(query, args);
      return res;
    } on DatabaseException catch (e) {
      await ErrorsReporter.genericThrow(
          e.toString(), Exception('DatabaseException. DB class rawQueryWords. query = $query'));
      throw Exception('Can not load words.');
    } on FormatException catch (e) {
      await ErrorsReporter.genericThrow(e.toString(),
          Exception('FormatException. DB class rawQueryWords. Query: $query \n arguments:$args'));
      throw Exception('Can not load your words, bad format.');
    } catch (e) {
      throw Exception('Cannot load words.');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> readWordsPaginatedOrderedByCreated({
    required int userId,
    required int offset,
    List<String> where = const [],
    List<dynamic> whereValues = const [],
    String? like,
    dynamic likeValue,
    int limit = 10,
  }) async {
    List<dynamic> whereArgs = [userId];
    if (whereValues.isNotEmpty) whereArgs.addAll(whereValues);
    String whereString = _prepareWhereFilter(where, like, likeValue);
    final String sql = '''
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
      WHERE $whereString  
      ORDER BY ${DbConsts.tableWords}.${DbConsts.colCreated} DESC
      LIMIT $limit OFFSET $offset''';

    try {
      final Database db = await instance.database;
      final List<Map<String, dynamic>> res = await db.rawQuery(sql, whereArgs);
      // print(res);
      return res;
    } on DatabaseException catch (e) {
      await ErrorsReporter.genericThrow(
          e.toString(),
          Exception(
              'DatabaseException. DB class readAllWordsByIdPaginated. UserId = $userId, query: $sql \n arguments:$whereArgs'));
      throw Exception('Can not load your words!');
    } on FormatException catch (e) {
      await ErrorsReporter.genericThrow(
          e.toString(),
          Exception(
              'FormatException. DB class readAllWordsByIdPaginated. UserId = $userId, query: $sql \n arguments:$whereArgs'));
      throw Exception('Can not load your words, bad format.');
    } catch (e) {
      throw Exception('Cannot load your words.');
    }
  }

  String _prepareWhereFilter(List<String> where, String? like, dynamic likeValue) {
    String whereString = ' ${DbConsts.tableWords}.${DbConsts.colWUserId} =?';

    if (where.isNotEmpty) {
      // WHERE words_table.userId=? AND words_table.categoryId=?
      final String whereFromArray =
          instance.prepareRawAndFilterFromArray(DbConsts.tableWords, where);
      whereString = '$whereString AND $whereFromArray';
    }
    String? likeString;
    if (like != null) {
      // catchword LIKE %home%
      // WHERE words_table.userId =? AND words_table.categoryId =? AND catchword LIKE %home%
      if (likeValue != null) {
        likeString = " AND $like LIKE '%$likeValue%'";
      } else {
        likeString = " AND $like LIKE '%'";
      }
      whereString = '$whereString$likeString';
    }
    return whereString;
  }
}
