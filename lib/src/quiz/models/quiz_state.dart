import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/quiz/models/models.dart';

class QuizState {
  const QuizState(
      {required this.currentUserWordsIds,
      required this.inGameWords,
      required this.notPlayedIds,
      required this.question,
      required this.options,
      required this.guessingWordPoints,
      required this.successId,
      required this.words,
      this.attempts = 0,
      this.didUserGuess = false,
      this.gamePoints = 0,
      this.isClueOpen = false,
      this.isClueShown = false,
      this.isLocked = false,
      this.roundPoints = 5});

  final List<Word> words;
  final List<int> currentUserWordsIds;
  final List<int> notPlayedIds;
  final List<Word> inGameWords;
  final Question question;
  final List<Option> options;
  final int guessingWordPoints;
  final int successId;
  final int attempts;
  final bool didUserGuess;
  final int gamePoints;
  final bool isClueOpen;
  final bool isClueShown;
  final bool isLocked;
  final int roundPoints;

  QuizState copyWith(
      {List<Word>? words,
      List<int>? currentUserWordsIds,
      List<int>? notPlayedIds,
      List<Word>? inGameWords,
      Question? question,
      List<Option>? options,
      int? guessingWordPoints,
      int? gamePoints,
      int? successId,
      int? attempts,
      bool? didUserGuess,
      bool? isClueOpen,
      bool? isClueShown,
      bool? isLocked,
      int? roundPoints}) {
    return QuizState(
      words: words ?? this.words,
      currentUserWordsIds: currentUserWordsIds ?? this.currentUserWordsIds,
      notPlayedIds: notPlayedIds ?? this.notPlayedIds,
      inGameWords: inGameWords ?? this.inGameWords,
      question: question ?? this.question,
      options: options ?? this.options,
      guessingWordPoints: guessingWordPoints ?? this.guessingWordPoints,
      gamePoints: gamePoints ?? this.gamePoints,
      successId: successId ?? this.successId,
      attempts: attempts ?? this.attempts,
      didUserGuess: didUserGuess ?? this.didUserGuess,
      isClueOpen: isClueOpen ?? this.isClueOpen,
      isClueShown: isClueShown ?? this.isClueShown,
      isLocked: isLocked ?? this.isLocked,
      roundPoints: roundPoints ?? this.roundPoints,
    );
  }

  @override
  String toString() {
    return 'QuizState: isLocked $isLocked, attempts: $attempts, didUserGuess: $didUserGuess, gamePoints: $gamePoints, options: $options, inGameWords: $inGameWords';
  }

  @override
  operator ==(other) =>
      other is QuizState &&
      other.inGameWords == inGameWords &&
      other.words == words &&
      other.currentUserWordsIds == currentUserWordsIds &&
      other.notPlayedIds == notPlayedIds &&
      other.question == question &&
      other.options == options &&
      other.guessingWordPoints == guessingWordPoints &&
      other.gamePoints == gamePoints &&
      other.successId == successId &&
      other.attempts == attempts &&
      other.didUserGuess == didUserGuess &&
      other.isClueOpen == isClueOpen &&
      other.isClueShown == isClueShown &&
      other.isLocked == isLocked &&
      other.roundPoints == roundPoints;

  @override
  int get hashCode => Object.hashAll([
        words,
        currentUserWordsIds,
        notPlayedIds,
        inGameWords,
        question,
        options,
        guessingWordPoints,
        gamePoints,
        successId,
        attempts,
        didUserGuess,
        isClueOpen,
        isClueShown,
        isLocked,
        roundPoints
      ]);
}
