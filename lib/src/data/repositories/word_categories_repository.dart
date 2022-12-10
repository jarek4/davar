import 'package:davar/locator.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/domain/i_word_categories_local_db.dart';
import 'package:davar/src/domain/i_word_categories_repository.dart';
import 'package:davar/src/errors_reporter/errors_reporter.dart';
import 'package:flutter/foundation.dart';

class WordCategoriesRepository implements IWordCategoriesRepository<WordCategory> {
  final IWordCategoriesLocalDb _localDB = locator<IWordCategoriesLocalDb<Map<String, dynamic>>>();

  @override

  /// Returns created item id. -1 if already exists, 0 if conflict
  /// not longer then 20 characters!
  Future<int> create(WordCategory category) async {
    try {
      Map<String, dynamic> asJson = category.toJson();
      // remove "id" so database can autoincrement it!
      asJson.remove('id');
      int res = await _localDB.createWordCategory(asJson);
      return res;
    } on FormatException catch (e) {
      await ErrorsReporter.genericThrow(e.toString(),
          Exception('FormatException. WordCategoriesRepository create(category:$category)'));
    } catch (e) {
      if (kDebugMode) print('WordCategoriesRepository create ERROR: $e');
    }
    return 0;
  }

  @override

  /// Returns the number of rows affected. -1 on error
  Future<int> delete(int id) async {
    try {
      int res = await _localDB.deleteWordCategory(id);
      return res;
    } on FormatException catch (e) {
      await ErrorsReporter.genericThrow(
          e.toString(), Exception('FormatException. WordCategoriesRepository delete(id:$id)'));
    } catch (e) {
      if (kDebugMode) print('WordCategoriesRepository delete ERROR: $e');
    }
    return -1;
  }

  @override

  /// Returns the number of changes made  -1 on error
  /// not longer then 20 characters!
  Future<int> update(WordCategory category) async {
    try {
      int res = await _localDB.updateWordCategory(category.toJson());
      return res;
    } on FormatException catch (e) {
      await ErrorsReporter.genericThrow(e.toString(),
          Exception('FormatException. WordCategoriesRepository update(category:$category)'));
    } catch (e) {
      if (kDebugMode) print('WordCategoriesRepository update ERROR: $e');
    }
    return -1;
  }

  @override
  Future<WordCategory?> read(int id) async {
    try {
      Map<String, dynamic>? res = await _localDB.readWordCategory(id) as Map<String, dynamic>;
      if (res.isNotEmpty) return WordCategory.fromJson(res);
    } on FormatException catch (e) {
      await ErrorsReporter.genericThrow(
          e.toString(), Exception('FormatException. WordCategoriesRepository read(Id:$id)'));
    } catch (e) {
      if (kDebugMode) print('WordCategoriesRepository read ERROR: $e');
    }
    return null;
  }

  @override
  Future<List<WordCategory>> readAll(int userId) async {
    List<WordCategory> models = [];
    try {
      List<Map<String, dynamic>> resp =
          await _localDB.readAllWordCategory(userId) as List<Map<String, dynamic>>;
      if (resp.isNotEmpty) {
        models = resp.map((element) => WordCategory.fromJson(element)).toList();
      }
    } on FormatException catch (e) {
      await ErrorsReporter.genericThrow(e.toString(),
          Exception('FormatException. WordCategoriesRepository readAll(userId:$userId)'));
    } catch (e) {
      if (kDebugMode) print('WordCategoriesRepository readAll ERROR: $e');
    }
    return models;
  }
}
