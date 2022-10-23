// ignore_for_file: avoid_print

import 'package:davar/locator.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/domain/i_words_repository.dart';
import 'package:flutter/foundation.dart';

enum WordsProviderStatus { error, loading, success }

class WordsProvider with ChangeNotifier {
  WordsProvider(this._user) {
    _fetchWords();
  }

  final User _user;

  final IWordsRepository<Word> _wordsRepository = locator<IWordsRepository<Word>>();

  List<Word> _words = [];
  WordsProviderStatus _status = WordsProviderStatus.success;
  String _errorMsg = '';

  WordsProviderStatus get status => _status;

  List<Word> get words => _words;

  String get wordsErrorMsg => _errorMsg;

  Future<void> create(Word word) async {
    _status = WordsProviderStatus.loading;
    notifyListeners();
    try {
      final int res = await _wordsRepository.create(word);
      if (res == -1) {
        _errorMsg = 'The word: ${word.catchword} was not saved!';
        _status = WordsProviderStatus.success;
        notifyListeners();
        return;
      }
      _errorMsg = '';
      _status = WordsProviderStatus.success;
      _words = [word, ..._words];
      notifyListeners();
    } catch (e) {
      _errorMsg = 'Some thing has happened 🥴\n The word: ${word.catchword} is not created!';
      _status = WordsProviderStatus.error;
      notifyListeners();
      print(e);
    }
  }

  Future<void> delete(int id) async {
    _errorMsg = '';
    _status = WordsProviderStatus.loading;
    notifyListeners();
    try {
      final int res = await _wordsRepository.delete(id);
      if (res == -1) {
        _errorMsg = 'The last change is not saved!';
        _status = WordsProviderStatus.success;
        notifyListeners();
        return;
      }
      await _fetchWords();
    } catch (e) {
      _errorMsg = 'Some thing has happened 🥴\n The word is not deleted!';
      _status = WordsProviderStatus.success;
      notifyListeners();
      print(e);
    }
  }

  Future<void> triggerFavorite(int id) async {
    // if word is favored isFavorite=1, if it is NOT isFavorite=0
    _errorMsg = '';
    _status = WordsProviderStatus.loading;
    notifyListeners();
    final Word word = _words.where((Word i) => i.id == id).first;
    final int newFavValue = word.isFavorite == 0 ? 1 : 0;
    final Word updated = word.copyWith(isFavorite: newFavValue);
    final List<Word> newState =
        _words.take(_words.length).map((Word i) => i.id == id ? updated : i).toList();
    _words = newState;
    try {
      final int? res = await _wordsRepository.rawUpdate(['isFavorite'], [newFavValue], id);
      if (res == null) _errorMsg = 'The last change is not saved!';
    } catch (e) {
      _errorMsg = 'The last change is not saved! Try to restart the application';
      print(e);
    }
    notifyListeners();
  }

  Future<void> _fetchWords() async {
    _errorMsg = '';
    _status = WordsProviderStatus.loading;
    notifyListeners();
    try {
      _words = await _wordsRepository.readAll(_user.id);
      _status = WordsProviderStatus.success;
      notifyListeners();
    } catch (e) {
      _errorMsg = 'Some thing bad has happened 🥴\n Try to restart the application';
      _status = WordsProviderStatus.error;
      notifyListeners();
      print(e);
    }
  }
}
