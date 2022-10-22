// ignore_for_file: avoid_print

import 'package:davar/locator.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/domain/i_word_categories_local_db.dart';
import 'package:davar/src/domain/i_word_categories_repository.dart';

class WordCategoriesRepository implements IWordCategoriesRepository<WordCategory> {
  final IWordCategoriesLocalDb _localDB = locator<IWordCategoriesLocalDb<Map<String, dynamic>>>();

  @override
  Future<int> create(WordCategory category) async {
    Map<String, dynamic> asJson = category.toJson();
    // remove "id" so database can autoincrement it!
    asJson.remove('id');
    try {
      int res = await _localDB.createWordCategory(asJson);
      return res;
    } catch (e) {
      print(e);
      return -1;
    }
  }

  @override
  Future<int> delete(int id) {
    // TODO: implement remove
    throw UnimplementedError();
  }

  @override
  Future<int> update(WordCategory category) async {
    Map<String, dynamic> asJson = category.toJson();
    try {
      int res = await _localDB.updateWordCategory(asJson);
      return res;
    } catch (e) {
      print(e);
      return -1;
    }
  }

  @override
  Future<WordCategory?> read(int id) async {
    try {
      Map<String, dynamic>? res = await _localDB.readWordCategory(id) as Map<String, dynamic>;
      Map<String, dynamic>? commonNoCategory = await _localDB.readWordCategory(id) as Map<String, dynamic>;
      print('WordCategoriesRepository read resp: ${res.toString()}');
      if (res.isEmpty) return null;
      return WordCategory.fromJson(res);
    } catch (e) {
      print('WordCategoriesRepository read ERROR: $e');
      return null;
    }
  }

  @override
  Future<List<WordCategory>> readAll(int userId) async {
    List<WordCategory> entities = [];
    try {
      List<Map<String, dynamic>> resp =
          await _localDB.readAllWordCategory(userId) as List<Map<String, dynamic>>;
      Map<String, dynamic>? commonNoCategory = await _localDB.readWordCategory(1) as Map<String, dynamic>;
      print('commonNoCategory: $commonNoCategory');
      if (resp.isNotEmpty) {
        entities = resp.map((element) => WordCategory.fromJson(element)).toList();
      }
      /*if (commonNoCategory.isNotEmpty) {
        entities.add(WordCategory.fromJson(commonNoCategory[0]));
      }*/
      // print('WordCategoriesRepository readAll resp: ${resp.toString()}');
    } catch (e) {
      print('WordCategoriesRepository readAll ERROR: $e');
    }
    return entities;
  }
}
