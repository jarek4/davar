import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/domain/i_words_statistics.dart';
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WordsStatisticsService implements IWordsStatistics {
  static const String _highest = utils.AppConst.statisticsItemWithHighestPoints;
  static const String _lowest = utils.AppConst.statisticsItemWithLeastPoints;
  static const String _sQuantity = utils.AppConst.statisticsSentencesQuantity;
  static const String _wQuantity = utils.AppConst.statisticsWordsQuantity;
  static const String _date = utils.AppConst.statisticsLastUpdateDate;

  @override
  /// <String>['catchword', 'points', 'id']
  Future<bool> saveItemWithHighestPoints(List<String> item) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final isSaved = await prefs.setStringList(_highest, item);
      return isSaved;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  /// <String>['catchword', 'points', 'id']
  @override
  Future<List<String>> readItemWithHighestPoints() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String>? items = prefs.getStringList(_highest);
      if (items == null) return ['', '0', '0'];
      //print('readItemWithHighestPoints items = $items');
      return items;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ['', '0', '0'];
    }
  }

  @override
  /// <String>['catchword', 'points', 'id']
  Future<bool> saveItemWithLowestPoints(List<String> item) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final isSaved = await prefs.setStringList(_lowest, item);
      return isSaved;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  /// <String>['catchword', 'points', 'id']
  @override
  Future<List<String>> readItemWithLowestPoints() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String>? items = prefs.getStringList(_lowest);
      //print('readItemWithLowestPoints items = $items');
      if (items == null) return ['', '0', '0'];
      return items;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ['', '0', '0'];
    }
  }

  @override
  Future<int> readSentencesQuantity() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int? quantity = prefs.getInt(_sQuantity);
      //print('readSentencesQuantity points = $quantity');
      return quantity ?? 0;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return -1;
    }
  }

  @override
  Future<int> readWordsQuantity() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int? quantity = prefs.getInt(_wQuantity);
      //print('readWordsQuantity points = $quantity');
      return quantity ?? 0;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return -1;
    }
  }

  @override
  Future<bool> saveSentencesQuantity(int value) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return await prefs.setInt(_sQuantity, value);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  @override
  Future<bool> saveWordsQuantity(int value) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return await prefs.setInt(_wQuantity, value);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  @override
  Future<String> readUpdateDate() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? date = prefs.getString(_date);
      //print('readWordsQuantity points = $quantity');
      return date ?? '';
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return '';
    }
  }

  @override
  Future<bool> saveUpdateDate(String date) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_date, date);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }
}
