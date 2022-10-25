// ignore_for_file: avoid_print
import 'dart:async';

import 'package:davar/locator.dart';
import 'package:davar/src/data/local/database/db_consts.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/domain/i_words_local_db.dart';
import 'package:davar/src/domain/i_words_repository.dart';

class WordsRepository implements IWordsRepository<Word> {
  // word max 25 characters, sentence 50.

  final IWordsLocalDb _localDB = locator<IWordsLocalDb<Map<String, dynamic>>>();

  @override

  /// Returns the id of the last inserted row. -1 if error,  0 if conflict
  Future<int> create(Word item) async {
    Map<String, dynamic> asJson = item.toJson();
    // DateTime.now() -> 2014-02-15 08:57:47.812
    // oIso8601String() -> 2014-02-15T08:57:47.812
    DateTime now = DateTime.now();
    String isoDate = now.toIso8601String().split('.').first;
    // remove "id" so database will can autoincrement it!
    asJson.remove('id');
    asJson[DbConsts.colCreated] = isoDate;
    try {
      int res = await _localDB.createWord(asJson);
      return res;
    } catch (e) {
      print('WordsRepository create(item.catchword: ${item.catchword}) Error: $e');
      return -1;
    }
  }

  @override

  ///Returns the number of rows affected. -1 on error
  Future<int> delete(int itemId) async {
    try {
      int res = await _localDB.deleteWord(itemId);
      return res;
    } catch (e) {
      print('WordsRepository delete(id:$itemId) Error: $e');
      return -1;
    }
  }

  @override

  /// Null if error
  Future<List<Word>?> rawQuery(String query, List arguments) async {
    try {
      List<Map<String, dynamic>> res =
          await _localDB.rawQueryWords(query, arguments) as List<Map<String, dynamic>>;
      if (res.isNotEmpty) return [];
      return res.map((element) => Word.fromJson(element)).toList();
    } catch (e) {
      print('WordsRepository rawQuery Error: $e');
      return null;
    }
  }

  @override

  /// returns the number of changes made. Null if error
  Future<int?> rawUpdate(List<String> columns, List arguments, int wordId) async {
    try {
      int res = await _localDB.rawWordUpdate(columns: columns, values: arguments, wordId: wordId);
      return res;
    } catch (e) {
      print('WordsRepository rawUpdate Error: $e');
      return null;
    }
  }

  @override
  Future<List<Word>> readAll(int userId) async {
    try {
      List<Map<String, dynamic>> resp =
          await _localDB.readAllWords(userId) as List<Map<String, dynamic>>;
      if (resp.isEmpty) return [];
      return resp.map((element) => Word.fromJson(element)).toList();
    } catch (e) {
      print('WordsRepository readAll(userId:$userId) Error: $e');
      return [];
    }
  }

  @override

  /// returns the number of changes made. -1 on error
  Future<int> update(Word item) async {
    try {
      int res = await _localDB.updateWord(item);
      return res;
    } catch (e) {
      print('WordsRepository update Error: $e');
      return -1;
    }
  }
}
