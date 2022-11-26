class DavarStatistic {
  const DavarStatistic({
    this.date = 'never',
    this.wordsNumber = 0,
    this.sentencesNumber = 0,
    this.mostPointsWord = const <String>['', '0', '0'],
    this.leastPointsWord = const <String>['', '0', '0'],
    this.highestQuizScore = 0,
  });

  final String date;
  final int wordsNumber;
  final int sentencesNumber;
  final List<String> mostPointsWord; // <String>['catchword', 'points', 'id']
  final List<String> leastPointsWord; // <String>['catchword', 'points', 'id']
  final int highestQuizScore;

  DavarStatistic copyWith(
      {String? date,
      int? wordsNumber,
      int? sentencesNumber,
      List<String>? mostPointsWord,
      List<String>? leastPointsWord,
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

  @override
  String toString() {
    return 'DavarStatistic:\n date: $date, wordsNumber: $wordsNumber, sentencesNumber: $sentencesNumber, highestQuizScore: $highestQuizScore;\n';
  }

  @override
  bool operator ==(Object other) {
    if (other is DavarStatistic) {
      if (other.date != date ||
          other.wordsNumber != wordsNumber ||
          other.sentencesNumber != sentencesNumber ||
          other.highestQuizScore != highestQuizScore) {
        return false;
      }
      final int lowest = leastPointsWord.length;
      final int most = mostPointsWord.length;
      if (lowest != other.leastPointsWord.length) return false;
      if (most != other.mostPointsWord.length) return false;
      for (int i = 0; i < lowest; i++) {
        if (leastPointsWord[i] != other.leastPointsWord[i]) return false;
      }
      for (int i = 0; i < most; i++) {
        if (mostPointsWord[i] != other.mostPointsWord[i]) return false;
      }
      return true;
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(
      date, wordsNumber, sentencesNumber, mostPointsWord, leastPointsWord, highestQuizScore);
}
