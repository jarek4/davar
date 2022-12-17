import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/providers/providers.dart';
import 'package:davar/src/statistics_services/quiz_statistics_service.dart';
import 'package:flutter/foundation.dart';

import 'models/models.dart';

enum QuizProviderStatus { error, loading, success }

class QuizProvider with ChangeNotifier, QuizStatisticsService {
  QuizProvider(this._wordsProvider) {
    _prepare();
  }

  final WordsProvider _wordsProvider;

  late QuizState _state;

  // last saved quiz highest score from statistics (saving current quiz score)
  int _previewHighestScore = 0;

  QuizState get state => _state;

  QuizProviderStatus _status = QuizProviderStatus.loading;

  QuizProviderStatus get status => _status;

  String _errorMsg = '';

  String get errorMsg => _errorMsg;

  Future<void> _prepare() async {
    _status = QuizProviderStatus.loading;
    _errorMsg = '';
    notifyListeners();
    try {
      final int lastSavedScore = await _readHighestScore();
      final List<Word> words = await _wordsProvider.readAllWords().catchError((e) {
        if (kDebugMode) print('QUIZ-readLastQuizSavedScore E: $e');
        return <Word>[];
      }).timeout(const Duration(seconds: 7), onTimeout: () => <Word>[]);
      List<Word> inGameWords = [];
      if (words.isNotEmpty && words.length >= 3) {
        // .getRange(0, 3) need to have at least 3 items in list for quiz!
        inGameWords = (words.toList()..shuffle()).getRange(0, 3).toList();
      }

      if (words.isEmpty || inGameWords.isEmpty) {
        // no words fetched from database, show error and return
        _onPrepareStateError();
        return;
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
      _previewHighestScore = lastSavedScore;
      notifyListeners();
    } catch (e) {
      _errorMsg = 'Some error occurred 🥴\n Try to restart the application';
      _status = QuizProviderStatus.error;
      notifyListeners();
      if (kDebugMode) print('QuizProvider_prepare Error:\n $e');
    }
  }

  void _onPrepareStateError() {
    _state = const QuizState(
      words: [],
      currentUserWordsIds: [],
      inGameWords: [],
      guessingWordPoints: 0,
      notPlayedIds: [],
      question: Question(inGameWords: []),
      options: [Option(text: '-', wordId: 0)],
      successId: 0,
    );
    _errorMsg = 'Still is loading! Please restart application!';
    _status = QuizProviderStatus.error;
    notifyListeners();
  }

  List<Option> _makeOptions(List<Word> inGameWords) {
    if (inGameWords.isEmpty) return <Option>[];
    List<Option> options = [];
    Word first = inGameWords[0];
    Option correct = Option(text: first.userTranslation, wordId: first.id, isCorrect: true);
    options.add(correct);
    List<Option> notCorrect =
        inGameWords.sublist(1).map((e) => Option(text: e.userTranslation, wordId: e.id)).toList();
    options.addAll(notCorrect);
    // the correct answer appears in various positions
    options.shuffle();
    return options;
  }

  void onClueDemand() {
    // Takes 1 point only once, regardless how many times was opened/closed.
    // If clue is empty don't subtract points!
    if (_state.isLocked) return; // game is over, player won or lost
    final String? clue = _state.inGameWords[0].clue;
    final bool isClueNullOrEmpty = clue == null || clue.isEmpty;
    if (_state.isClueShown || isClueNullOrEmpty) {
      // the clue was already shown or clue was not added
      _openClue();
      return;
    }
    // the game is not over, and the clue has not yet been shown.
    final int difference = _state.roundPoints - 1;
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
    // check is the selected option locked already - prevents to select multiple times
    final bool isOptionAlreadySelected =
        _state.options.firstWhere((e) => e.wordId == option.wordId).isSelected;
    if (isOptionAlreadySelected || _state.isLocked) return;
    final bool isCorrect = option.isCorrect;
    final List<Option> updatedOptions = _markOptionAsSelected(option.wordId);
    final int currentAttempts = _state.attempts + 1;
    final bool willBeLocked = currentAttempts >= 2 || isCorrect;
    final int calculatedPoints = _calculatePoints(isCorrect, willBeLocked);

    _state = _state.copyWith(
      attempts: currentAttempts,
      didUserGuess: isCorrect,
      // calculate total game points
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

  // prevent to select more then one
  List<Option> _markOptionAsSelected(int id) {
    return _state.options.map((e) => e.wordId == id ? e.copyWith(isSelected: true) : e).toList();
  }

  int _calculatePoints(bool isCorrect, bool isToLock) {
    int currentPoints = _state.roundPoints;
    //player guessed the first time
    if (isCorrect) return currentPoints;
    if (isToLock) return 0;

    // subtract 1 point (no negative points):
    currentPoints = (currentPoints - 1) > 0 ? (currentPoints - 1) : 0;

    return currentPoints;
  }

  Future<void> _onSuccess(int wordId, int scoredWordPoints) async {
    // find out previews words points
    final Word item = _state.inGameWords.firstWhere((element) => element.id == wordId);
    final int points = item.points + scoredWordPoints;
    await _incrementWordsPointsIntoStorage(item.copyWith(points: points));
    // save to statistics
    if (_state.gamePoints > _previewHighestScore) {
      final bool isSaved = await _saveTotalGamePointsForStatistics(_state.gamePoints);
      if (!isSaved) {
        _errorMsg = 'Total game score not saved!';
        notifyListeners();
      }
    }
  }

  Future<void> _incrementWordsPointsIntoStorage(Word word) async {
    // update word's points
    await _wordsProvider.update(word).catchError((e) {
      if (kDebugMode) print('QUIZ increment-Points-Storage(id: ${word.id}) update.catch: $e');
    }).timeout(const Duration(seconds: 5), onTimeout: () {
      if (kDebugMode) print('QUIZ incrementWordsPointsIntoStorage(id: ${word.id}) onTimeout');
    });
  }

  Future<void> onNext() async {
    List<int> notPlayedIds = _state.notPlayedIds;
    List<Word> newInGameWords = _state.inGameWords;

    if (notPlayedIds.length >= 3) {
      // load new items to inGameWords
      final List<int> inGameIds = _mixIds(notPlayedIds).getRange(0, 3).toList();
      // newInGameWords.removeRange(0, newInGameWords.length); //?
      newInGameWords = _getWordsFromStateByIds(inGameIds);
    } else {
      final int idsQuantity = notPlayedIds.length;
      switch (idsQuantity) {
        case 2:
          List<Word> replacements = _getWordsFromStateByIds(notPlayedIds);
          // replace current inGameWords[0] to inGameWords[2], notPlayedIds don't contain this item!
          newInGameWords = newInGameWords.reversed.toList();
          newInGameWords.replaceRange(0, 2, replacements);
          break;
        case 1:
          Word replacement = _getWordsFromStateByIds(notPlayedIds).first;
          // check do inGameWords contains replacement? IF do, move it at 0 index.
          final int atIndex = newInGameWords.indexOf(replacement);
          if (atIndex != -1) {
            newInGameWords.removeAt(atIndex);
            newInGameWords.insert(0, replacement);
          } else {
            newInGameWords = newInGameWords.reversed.toList();
            newInGameWords.removeAt(0);
            newInGameWords.insert(0, replacement);
          }
          break;
        default:
          return;
      }
    }
    // remove inGameIds[0] - the looking for word - from state.notPlayedIds
    List<int> newNotPlayedIds = notPlayedIds.where((e) => e != newInGameWords[0].id).toList();

    _state = _state.copyWith(
        attempts: 0,
        didUserGuess: false,
        inGameWords: newInGameWords,
        isClueOpen: false,
        isClueShown: false,
        isLocked: false,
        notPlayedIds: newNotPlayedIds,
        roundPoints: 3,
        question: Question(inGameWords: newInGameWords),
        options: _makeOptions(newInGameWords),
        successId: newInGameWords[0].id);
    notifyListeners();
  }

  List<int> _mixIds(List<int> list) {
    final List<int> mixed = list.take(list.length).toList();
    mixed.shuffle();
    return mixed;
  }

  List<Word> _getWordsFromStateByIds(List<int> ids) {
    List<Word> items = [];
    if (ids.isEmpty) return items;
    for (int index = 0; index < ids.length; index++) {
      items.add(_state.words.firstWhere((e) => e.id == ids[index]));
    }
    return items;
  }

  Future<bool> _saveTotalGamePointsForStatistics(int totalPoints) async {
    // IQuizStatistics
    return await saveHighestQuizScore(totalPoints).catchError((e) {
      if (kDebugMode) print('QUIZ-saveTotalGamePointsForStatistics E: $e');
      return false;
    }).timeout(const Duration(seconds: 5), onTimeout: () => false);
  }

  Future<int> _readHighestScore() async {
    // IQuizStatistics
    final int points = await readHighestQuizScore().catchError((e) {
      if (kDebugMode) print('QUIZ-readLastQuizSavedScore E: $e');
      return 0;
    }).timeout(const Duration(seconds: 5), onTimeout: () => 0);
    final int lastSavedScore = points;
    return lastSavedScore;
  }

  Future<void> onQuit() async {
    if (_state.gamePoints > _previewHighestScore) {
      final bool isSaved = await _saveTotalGamePointsForStatistics(_state.gamePoints);
      if (!isSaved) {
        _errorMsg = 'Total game score not saved!';
        notifyListeners();
      }
    }
  }
}
