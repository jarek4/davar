import 'dart:async';

import 'package:davar/locator.dart';
import 'package:davar/src/data/local/database/db_consts.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/domain/i_words_local_db.dart';
import 'package:davar/src/domain/i_words_repository.dart';

class WordsRepository implements IWordsRepository<Word> {
  // List<Word> _words = [];

  final IWordsLocalDb _localDB = locator<IWordsLocalDb<Map<String, dynamic>>>();

  @override
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
      print(e);
      return -1;
    }
  }

  @override
  Future<int> delete(int itemId) async {
    try {
      int res = await _localDB.deleteWord(itemId);
      return res;
    } catch (e) {
      print(e);
      throw Exception('Word not deleted. Sorry!');
    }
  }

  @override
  Future<List<Word>> rawQuery(String query, List arguments) async {
    List<Word> entities = [];
    try {
      List<Map<String, dynamic>> res =
          await _localDB.rawQueryWords(query, arguments) as List<Map<String, dynamic>>;
      if (res.isNotEmpty) {
        entities = res.map((element) => Word.fromJson(element)).toList();
      }
    } catch (e) {
      print(e);
      throw Exception('Word not deleted. Sorry!');
    }
    return entities;
  }

  @override
  Future<int> rawUpdate(List<String> columns, List arguments, int wordId) async {
    try {
      int res = await _localDB.rawWordUpdate(columns: columns, values: arguments, wordId: wordId);
      return res;
    } catch (e) {
      print(e);
      throw Exception('Word not deleted. Sorry!');
    }
  }

  @override
  Future<List<Word>> readAll(int userId) async {
    List<Word> entities = [];
    try {
      // await _localDB.createWord(const Word(catchword: 'catchword1', id: 2, userId: 1, userTranslation: 'transl1').toJson());
      // await _localDB.createWord(const Word(catchword: 'catchword2', id: 3, userId: 1, userTranslation: 'transl2').toJson());
      List<Map<String, dynamic>> resp =
          await _localDB.readAllWords(userId) as List<Map<String, dynamic>>;
      if (resp.isNotEmpty) {
        entities = resp.map((element) => Word.fromJson(element)).toList();
      }
    } catch (e) {
      print(e);
    }

    return entities;
  }

  @override
  Future<int> update(Word item) async {
    try {
      int res = await _localDB.updateWord(item);
      return res;
    } catch (e) {
      print(e);
      throw Exception('Word not updated. Sorry!');
    }
  }
}
