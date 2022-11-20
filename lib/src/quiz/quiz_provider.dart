// ignore_for_file: avoid_print
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/providers/providers.dart';
import 'package:flutter/foundation.dart';

import 'models/models.dart';

enum QuizProviderStatus { error, loading, success }

class QuizProvider with ChangeNotifier {
  QuizProvider(this._wordsProvider) {
    _prepare();
  }

  final WordsProvider _wordsProvider;

  late QuizState _state;

  QuizState get state => _state;

  static List<Option> _makeOptions(List<Word> inGameWords) {
    if (inGameWords.isEmpty) return <Option>[];
    List<Option> options = [];
    Word first = inGameWords[0];
    Option correct = Option(text: first.userTranslation, wordId: first.id, isCorrect: true);
    options.add(correct);
    List<Option> notCorrect =
        inGameWords.sublist(1).map((e) => Option(text: e.userTranslation, wordId: e.id)).toList();
    options.addAll(notCorrect);
    // options.shuffle();
    return options;
  }

  QuizProviderStatus _status = QuizProviderStatus.loading;

  QuizProviderStatus get status => _status;

  String _errorMsg = '';

  String get errorMsg => _errorMsg;

  Future<void> _prepare() async {
    _status = QuizProviderStatus.loading;
    _errorMsg = '';
    notifyListeners();
    try {
      await Future.delayed(const Duration(seconds: 2), () => print('QuizProvider_prepare delayed'));
      final List<Word> words = await _wordsProvider.readAllWords();
      List<Word> inGameWords = [];
      if (words.isNotEmpty && words.length >= 3) {
        // .getRange(0, 3) need to have at least 3 items in list for quiz!
        inGameWords = (words.toList()..shuffle()).getRange(0, 3).toList();
      }
      final List<int> currentUserWordsIds = words.map((e) => e.id).toList();
      final List<int> notPlayedIds =
          words.map((e) => e.id).where((element) => element != inGameWords[0].id).toList();
      final Question question = Question(inGameWords: inGameWords);
      final List<Option> options = _makeOptions(inGameWords);
      final int successId = inGameWords.isEmpty ? -1 : inGameWords[0].id;

      _state = QuizState(
        words: words,
        currentUserWordsIds: currentUserWordsIds,
        inGameWords: inGameWords,
        guessingWordPoints: inGameWords.isEmpty ? -1 : inGameWords[0].points,
        notPlayedIds: notPlayedIds,
        question: question,
        options: options,
        successId: successId,
      );
      _status = QuizProviderStatus.success;
      notifyListeners();
    } catch (e) {
      _errorMsg = 'Some error occurred 🥴\n Try to restart the application';
      _status = QuizProviderStatus.error;
      notifyListeners();
      print('QuizProvider_prepare Error:\n $e');
    }
  }

  void onClueDemand() {
    // Takes 2 points only once, regardless how many times was opened/closed.
    // If clue is empty don't subtract points!
    if (_state.isLocked) return; // game is over, player won or lost
    if (_state.isClueShown) {
      // the clue was already shown
      _openClue();
      return;
    }
    // the game is not over, and the clue has not yet been shown.
    final int difference = _state.roundPoints - 2;
    _state = _state.copyWith(
        isClueShown: true,
        roundPoints: difference > 0 ? difference : 0, // no negative points
        isClueOpen: true);
    notifyListeners();
  }

  void _openClue() {
    if (_state.isClueOpen) return;
    _state = _state.copyWith(isClueOpen: true);
    notifyListeners();
  }

  Future<void> onSelect(Option option) async {
    if (_state.isLocked) return;
    final bool isCorrect = option.isCorrect;
    final List<Option> updatedOptions = _markOptionAsSelected(option.wordId);
    final int currentAttempts = _state.attempts + 1;
    final bool willBeLocked = currentAttempts >= 2 || isCorrect;
    final int calculatedPoints = _calculatePoints(isCorrect, willBeLocked);

    _state = _state.copyWith(
      attempts: currentAttempts,
      didUserGuess: isCorrect,
      gamePoints: isCorrect ? (_state.gamePoints + calculatedPoints) : _state.gamePoints,
      isLocked: willBeLocked,
      isClueOpen: false,
      options: updatedOptions,
      roundPoints: calculatedPoints,
    );
    notifyListeners();

    if (isCorrect) {
      await _onSuccess(option.wordId, calculatedPoints);
    }
  }

  List<Option> _markOptionAsSelected(int id) {
    return _state.options.map((e) => e.wordId == id ? e.copyWith(isSelected: true) : e).toList();
  }

  int _calculatePoints(bool isCorrect, bool isToLock) {
    int currentPoints = _state.roundPoints;
    //player guessed the first time
    if (isCorrect) return currentPoints;
    if (isToLock) return 0;

    // subtract 2 points (no negative points):
    currentPoints = (currentPoints - 2) > 0 ? (currentPoints - 2) : 0;

    return currentPoints;
  }

  Future<void> _onSuccess(int wordId, int scoredWordPoints) async {
    // get the word by id, to find out previews words points
    final Word item = _state.inGameWords.firstWhere((element) => element.id == wordId);
    final int points = item.points + scoredWordPoints;
    await _incrementWordsPointsIntoStorage(item.copyWith(points: points));
  }

  Future<void> _incrementWordsPointsIntoStorage(Word word) async {
    // wordsCubit.update(id, 'points', points);
    // update word via wordProvider
    await _wordsProvider.update(word);
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setInt('ThemeMode', theme.index);
  }

  void onNext() {
    // check if there are at least 3 ids in state.notPlayedIds
    List<int> notPlayedIds = _state.notPlayedIds;
    if (notPlayedIds.length < 3) return;

    // fill up new state.inGameWords
    List<Word> newInGameWords = [];
    final List<int> inGameIds = notPlayedIds.getRange(0, 3).toList();
    for (int x = 0; x < inGameIds.length; x++) {
      newInGameWords.add(_state.words.firstWhere((e) => e.id == inGameIds[x]));
    }
    // remove inGameIds[0] - the correct one - from state.notPlayedIds
    List<int> newNotPlayedIds = notPlayedIds.where((e) => e != newInGameWords[0].id).toList();

    _state = _state.copyWith(
        attempts: 0,
        didUserGuess: false,
        inGameWords: newInGameWords,
        isClueOpen: false,
        isClueShown: false,
        isLocked: false,
        notPlayedIds: newNotPlayedIds,
        roundPoints: 5,
        question: Question(inGameWords: newInGameWords),
        options: _makeOptions(newInGameWords),
        successId: newInGameWords[0].id);
    notifyListeners();
  }
}
