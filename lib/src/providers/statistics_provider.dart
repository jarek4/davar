import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/providers/providers.dart';
import 'package:davar/src/providers/words_provider.dart';
import 'package:davar/src/statistics_services/statistics_service.dart';
import 'package:flutter/foundation.dart';

enum StatisticsProviderStatus { error, loading, success }

class StatisticsProvider with ChangeNotifier, QuizStatisticsService, WordsStatisticsService {
  StatisticsProvider(this._wordsProvider);

  final WordsProvider _wordsProvider;

  final StatisticsProviderStatus _status = StatisticsProviderStatus.success;

  StatisticsProviderStatus get status => _status;

  final String _errorMsg = '';

  String get errorMsg => _errorMsg;

  DavarStatistic _statistics = const DavarStatistic();

  DavarStatistic get statistics => _statistics;

  // loads data stored in SharedPreferences
  // fired when statistics screen is shown
  Future<DavarStatistic> loadPreviewsStatistics() async {
    final int quizScore = await readHighestQuizScore();
    final List<String> mostPoints = await readItemWithHighestPoints();
    final List<String> leastPoints = await readItemWithLowestPoints();
    final int words = await readWordsQuantity();
    final int sentences = await readSentencesQuantity();
    final String updateDate = await readUpdateDate();

    return _statistics = DavarStatistic(
      date: updateDate.isNotEmpty ? updateDate : '-',
      wordsNumber: words,
      sentencesNumber: sentences,
      mostPointsWord: mostPoints,
      leastPointsWord: leastPoints,
      highestQuizScore: quizScore,
    );
  }

  // when refresh button is pressed
  // collects data to save new DavarStatistic object in SharedPreferences.
  // Don't replace highestQuizScore!
  // updates _statistics field.
  Future<DavarStatistic> refreshStatistics() async {
    final String newDate = _getIsoDateString();
    final DavarStatistic ds =
        DavarStatistic(date: newDate, highestQuizScore: _statistics.highestQuizScore);
    final DavarStatistic updated = await _setWordsRepositoryStatistics(ds);
    // save fresh statistics
    await _recordStatistics(updated)
        .catchError((e) => false)
        .timeout(const Duration(seconds: 3), onTimeout: () => false);
    return _statistics = updated;
  }

  Future<DavarStatistic> _setWordsRepositoryStatistics(DavarStatistic st) async {
    final List<Word> allFromDb = await _wordsProvider.readAllWords();
    final int allFromDbQuantity = allFromDb.length;
    DavarStatistic tempStats = st;
    // found highest and least points
    if (allFromDbQuantity < 2) {
      const List<String> unavailable = ['unavailable', '0', '0'];
      tempStats = tempStats.copyWith(mostPointsWord: unavailable, leastPointsWord: unavailable);
    } else {
      allFromDb.sort((a, b) => a.points.compareTo(b.points)); // [a, b] where a < b
      final int lastIndex = allFromDbQuantity - 1;
      final List<String> mostPoints = [
        allFromDb[lastIndex].catchword,
        '${allFromDb[lastIndex].points}',
        '${allFromDb[lastIndex].id}'
      ];
      final List<String> leastPoints = [
        allFromDb[0].catchword,
        '${allFromDb[0].points}',
        '${allFromDb[0].id}'
      ];
      tempStats = tempStats.copyWith(mostPointsWord: mostPoints, leastPointsWord: leastPoints);
    }
    // founding words and sentences quantity
    final int wq = allFromDb.where((e) => e.isSentence == 0).toList().length;
    final int sq = allFromDbQuantity - wq;
    tempStats = tempStats.copyWith(wordsNumber: wq, sentencesNumber: sq);
    return tempStats;
  }

  Future<bool> _recordStatistics(DavarStatistic st) async {
    final bool sd = await saveUpdateDate(st.date).catchError((e) => false);
    final bool shp = await saveItemWithHighestPoints(st.mostPointsWord).catchError((e) => false);
    final bool slp = await saveItemWithLowestPoints(st.leastPointsWord).catchError((e) => false);
    final bool swq = await saveWordsQuantity(st.wordsNumber).catchError((e) => false);
    final bool ssq = await saveSentencesQuantity(st.sentencesNumber).catchError((e) => false);
    return sd && shp && slp && swq && ssq;
  }

  static String _getIsoDateString() {
    // oIso8601String() -> 2014-02-15T08:57:47.812
    return DateTime.now().toIso8601String().split('T').first;
  }
}
