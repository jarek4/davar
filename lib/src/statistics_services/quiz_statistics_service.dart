import 'package:davar/src/domain/i_quiz_statistics.dart';
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizStatisticsService implements IQuizStatistics {
  static const String _quiz = utils.AppConst.statisticsQuizHighestScore;

  @override
  Future<bool> saveHighestQuizScore(int value) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final isSaved = await prefs.setInt(_quiz, value);
      return isSaved;
    } catch (e) {
      if (kDebugMode) print('saveHighestQuizScoreWithDate Error: $e');
      return false;
    }
  }

  @override
  Future<int> readHighestQuizScore() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int? points = prefs.getInt(_quiz);
      return points ?? 0;
    } catch (e) {
      if (kDebugMode) print('readHighestQuizScoreWithDate Error: $e');
      return -1;
    }
  }
}
