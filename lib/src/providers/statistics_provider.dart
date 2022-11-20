import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/providers/words_provider.dart';
import 'package:flutter/foundation.dart';

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

  // DateTime.now() -> 2014-02-15 08:57:47.812 oIso8601String() -> 2014-02-15T08:57:47.812
  // static final DateTime _now = DateTime.now();
  // static final String _nowDate = _now.toIso8601String().split('T').first;

  DavarStatistic _statistics = DavarStatistic(
      date: DateTime.now(),
      wordsNumber: 0,
      sentencesNumber: 0,
      mostPointsWords3: [],
      leastPointsWords3: [],
      highestQuizScore: 0);

  DavarStatistic get statistics => _statistics;

  Future<DavarStatistic> loadStatistics() async {
    List<Word> all = _wordsProvider.words;
    _foundItemsNumber(all);
    if(all.length >= 2) _foundMostLeastPoints(all);
    return _statistics;
  }
  void _foundItemsNumber(List<Word> list) {
    List<Word> w = [];
    List<Word> s = [];
    for(Word item in list) {
      if(item.isSentence == 0) {
        w.add(item);
      }
      if(item.isSentence == 1) {
        s.add(item);
      }
    }
    _statistics = _statistics.copyWith(wordsNumber: w.length, sentencesNumber: s.length);
  }

  void _foundMostLeastPoints(List<Word> list) {
    final List<Word> nl = list;
    nl.sort((a, b) => a.points.compareTo(b.points));
    if(nl.length < 6) {
      _statistics = _statistics.copyWith(mostPointsWords3: [nl[0]], leastPointsWords3: [nl[nl.length - 1]]);
    } else {
      _statistics = _statistics.copyWith(
          mostPointsWords3: nl.getRange(0, 2).toList(),
          leastPointsWords3: nl.getRange(nl.length - 3, nl.length - 1).toList());
    }
  }

  }



class DavarStatistic {
  const DavarStatistic({
    required this.date,
    required this.wordsNumber,
    required this.sentencesNumber,
    required this.mostPointsWords3,
    required this.leastPointsWords3,
    required this.highestQuizScore,
  });

  final DateTime date;
  final int wordsNumber;
  final int sentencesNumber;
  final List<Word> mostPointsWords3;
  final List<Word> leastPointsWords3;
  final int highestQuizScore;

  DavarStatistic copyWith(
      {DateTime? date,
      int? wordsNumber,
      int? sentencesNumber,
      List<Word>? mostPointsWords3,
      List<Word>? leastPointsWords3,
      int? highestQuizScore}) {
    return DavarStatistic(
      date: date ?? this.date,
      wordsNumber: wordsNumber ?? this.wordsNumber,
      sentencesNumber: sentencesNumber ?? this.sentencesNumber,
      mostPointsWords3: mostPointsWords3 ?? this.mostPointsWords3,
      leastPointsWords3: leastPointsWords3 ?? this.leastPointsWords3,
      highestQuizScore: highestQuizScore ?? this.highestQuizScore,
    );
  }
}
