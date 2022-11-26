import 'package:davar/src/domain/i_quiz_statistics.dart';
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:shared_preferences/shared_preferences.dart';

class QuizStatisticsService implements IQuizStatistics {
  static const String _quiz = utils.AppConst.statisticsQuizHighestScore;

  @override

  /// value=points, date='2000-00-00'
  Future<bool> saveHighestQuizScore(int value) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
     // prefs.remove(_quiz);
      final isSaved = await prefs.setInt(_quiz, value);
      return isSaved;
    } catch (e) {
      print('saveHighestQuizScoreWithDate Error: $e');
      return false;
    }
  }

  @override

  /// <String>['points', 'date'] => ['2', '2000-00-00']
  Future<int> readHighestQuizScore() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.remove(_quiz);
      final int? points = prefs.getInt(_quiz);
      // print('readHighestQuizScoreWithDate items: $items');
      return points ?? 0;
    } catch (e) {
      print('readHighestQuizScoreWithDate Error: $e');
      return -1;
    }
  }
}
