import 'dart:async';

import 'package:davar/locator.dart';
import 'package:davar/src/data/local/database/db_consts.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/domain/i_words_local_db.dart';
import 'package:davar/src/domain/i_words_repository.dart';
import 'package:davar/src/errors_reporter/errors_reporter.dart';

class WordsRepository implements IWordsRepository<Word> {
  // word max 25 characters, sentence 50.

  final IWordsLocalDb _localDB = locator<IWordsLocalDb<Map<String, dynamic>>>();

  @override

  /// Returns the id of the last inserted row. -1 if error,  0 if conflict
  Future<int> create(Word item) async {
    Map<String, dynamic> asJson = item.toJson();
    // DateTime.now() -> 2014-02-15 08:57:47.812
    // oIso8601String() -> 2014-02-15T08:57:47.812
    final DateTime now = DateTime.now();
    final String isoDate = now.toIso8601String().split('.').first;
    // remove "id" - database will autoincrement it!
    asJson.remove('id');
    asJson[DbConsts.colCreated] = isoDate;
    try {
      final int res = await _localDB.createWord(asJson);
      return res;
    } on FormatException catch (e) {
      await ErrorsReporter.genericThrow(e.toString(),
          Exception('FormatException. WordsRepository create(Word item). item = $item'));
      return -1;
    } catch (e) {
      return -1;
    }
  }

  @override

  ///Returns the number of rows affected. -1 on error
  Future<int> delete(int itemId) async {
    try {
      final int res = await _localDB.deleteWord(itemId);
      return res;
    } catch (e) {
      return -1;
    }
  }

  @override

  ///Null if error. If not reading all columns - be aware when do Word.fromJson()!
  Future<List<Map<String, dynamic>>?> rawQuery(String query, List arguments) async {
    try {
      final List<Map<String, dynamic>> res =
          await _localDB.rawQueryWords(query, arguments) as List<Map<String, dynamic>>;
      if (res.isEmpty) return [];
      return res;
    } on FormatException catch (e) {
      await ErrorsReporter.genericThrow(
          e.toString(),
          Exception(
              'FormatException. WordsRepository rawQuery(). query = $query, args: $arguments'));
      return null;
    } catch (e) {
      return null;
    }
  }

  @override

  /// returns the number of changes made. Null if error
  Future<int?> rawUpdate(List<String> columns, List arguments, int wordId) async {
    try {
      final int res =
          await _localDB.rawWordUpdate(columns: columns, values: arguments, wordId: wordId);
      return res;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Word>> readAll(int userId) async {
    try {
      final List<Map<String, dynamic>> resp =
          await _localDB.readAllWords(userId) as List<Map<String, dynamic>>;
      if (resp.isEmpty) return [];
      return resp.map((element) => Word.fromJson(element)).toList();
    } on FormatException catch (e) {
      await ErrorsReporter.genericThrow(
          e.toString(), Exception('FormatException. WordsRepository readAll(userId:$userId)'));
      return [];
    } catch (e) {
      return [];
    }
  }

  @override

  /// returns the number of changes made. -1 on error
  Future<int> update(Word item) async {
    try {
      final int res = await _localDB.updateWord(item.toJson());
      return res;
    } on FormatException catch (e) {
      await ErrorsReporter.genericThrow(
          e.toString(), Exception('FormatException. WordsRepository update(Word $item)'));
      return -1;
    } catch (e) {
      return -1;
    }
  }

  @override
  Future<List<Word>> readAllPaginated({
    required int userId,
    int offset = 0,
    List<String> where = const [],
    List<dynamic> whereValues = const [],
    String? like,
    dynamic likeValue,
    int limit = 10,
  }) async {
    try {
      final List<Map<String, dynamic>> resp = await _localDB.readWordsPaginatedOrderedByCreated(
          userId: userId,
          offset: offset,
          limit: limit,
          where: where,
          whereValues: whereValues,
          like: like,
          likeValue: likeValue) as List<Map<String, dynamic>>;
      if (resp.isEmpty) return [];

      return resp.map((element) => Word.fromJson(element)).toList();
    } on FormatException catch (e) {
      await ErrorsReporter.genericThrow(
          e.toString(),
          Exception(
              'FormatException. WordsRepository readAllPaginatedById(). UserId = $userId,\n offset: $offset where: $where, like: $like'));
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Word?> readSingle(int id) async {
    try {
      final Map<String, dynamic> res = await _localDB.readWord(id);
      if (res.isEmpty) return null;
      return Word.fromJson(res);
    } on FormatException catch (e) {
      await ErrorsReporter.genericThrow(
          e.toString(), Exception('FormatException. WordsRepository readSingle(id:$id)'));
      return null;
    } catch (e) {
      return null;
    }
  }
}
