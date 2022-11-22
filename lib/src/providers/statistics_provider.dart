import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/providers/words_provider.dart';
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum StatisticsProviderStatus { error, loading, success }

class StatisticsProvider with ChangeNotifier {
  StatisticsProvider(this._wordsProvider) {
    // _prepare();
  }

  final WordsProvider _wordsProvider;

  StatisticsProviderStatus _status = StatisticsProviderStatus.success;

  StatisticsProviderStatus get status => _status;

  String _errorMsg = '';

  String get errorMsg => _errorMsg;

  DavarStatistic _statistics = const DavarStatistic();

  DavarStatistic get statistics => _statistics;

  static String _getIsoDateString() {
    // DateTime.now() -> 2014-02-15 08:57:47.812 oIso8601String() -> 2014-02-15T08:57:47.812
    return DateTime.now().toIso8601String().split('T').first;
  }

  Future<DavarStatistic> loadStatistics() async {
    List<Word> all = _wordsProvider.words;
    _foundItemsNumber(all);
    if (all.length >= 2) _foundMostLeastPoints(all);
    final int quizScore = await _cashedHighestQuizScore();
    _statistics = _statistics.copyWith(highestQuizScore: quizScore);
    return _statistics;
  }

  Future<DavarStatistic> loadPreviewsStatistics() async {
    List<Word> all = _wordsProvider.words;
    _foundItemsNumber(all);
    if (all.length >= 2) _foundMostLeastPoints(all);
    final int quizScore = await _cashedHighestQuizScore();
    _statistics = _statistics.copyWith(highestQuizScore: quizScore);
    return _statistics;
  }

  void _foundItemsNumber(List<Word> list) {
    List<Word> w = [];
    List<Word> s = [];
    for (Word item in list) {
      if (item.isSentence == 0) {
        w.add(item);
      }
      if (item.isSentence == 1) {
        s.add(item);
      }
    }
    _statistics = _statistics.copyWith(wordsNumber: w.length, sentencesNumber: s.length);
  }

  void _foundMostLeastPoints(List<Word> list) {
    final List<Word> nl = list;
    nl.sort((a, b) => a.points.compareTo(b.points)); // [a, b] and a < b
      _statistics =
          _statistics.copyWith(mostPointsWord: nl[nl.length - 1], leastPointsWord: nl[0]);

  }

  Future<int> _cashedHighestQuizScore() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? lastSavedScore = prefs.getInt(utils.AppConst.statisticsQuizHighestScore);
    return lastSavedScore ?? 0;
  }

  Future<Word> _cashedItemWithHighestPoints() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? items =
        prefs.getStringList(utils.AppConst.statisticsItemWithHighestPoints);
    return const Word(catchword: 'c', id: -22, userId: -3, userTranslation: 'u');
  }

  Future<Word> _cashedItemWithLeastPoints() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? items = prefs.getStringList(utils.AppConst.statisticsItemWithLeastPoints);
    return const Word(catchword: 'cc', id: -25, userId: -3, userTranslation: 'u');
  }
}

class DavarStatistic {
  const DavarStatistic({
    this.date = 'never',
    this.wordsNumber = 0,
    this.sentencesNumber = 0,
    this.mostPointsWord,
    this.leastPointsWord,
    this.highestQuizScore = 0,
  });

  final String date;
  final int wordsNumber;
  final int sentencesNumber;
  final Word? mostPointsWord;
  final Word? leastPointsWord;
  final int highestQuizScore;

  DavarStatistic copyWith(
      {String? date,
      int? wordsNumber,
      int? sentencesNumber,
      Word? mostPointsWord,
      Word? leastPointsWord,
      int? highestQuizScore}) {
    return DavarStatistic(
      date: date ?? this.date,
      wordsNumber: wordsNumber ?? this.wordsNumber,
      sentencesNumber: sentencesNumber ?? this.sentencesNumber,
      mostPointsWord: mostPointsWord ?? this.mostPointsWord,
      leastPointsWord: leastPointsWord ?? this.leastPointsWord,
      highestQuizScore: highestQuizScore ?? this.highestQuizScore,
    );
  }
}
