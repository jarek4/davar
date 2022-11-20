// ignore_for_file: avoid_print

import 'package:davar/locator.dart';
import 'package:davar/src/data/local/database/db_consts.dart';
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

  WordsProviderStatus _status = WordsProviderStatus.success;

  WordsProviderStatus get status => _status;

  String _errorMsg = '';

  String get wordsErrorMsg => _errorMsg;

  set errorMsg(String value) {
    if(_errorMsg != value) {
      _errorMsg = value;
      notifyListeners();
    }
  }

  List<Word> _words = [];

  List<Word> get words => _words;

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

  Future<List<Word>> readAllWords() async {
    _errorMsg = '';
    _status = WordsProviderStatus.loading;
    notifyListeners();
    try {
      final res = await _wordsRepository.readAll(_user.id);
      if(_words != res) {
        _words = res;
        _status = WordsProviderStatus.success;
        notifyListeners();
      }
      return res;
    } catch (e) {
      print(e);
      _status = WordsProviderStatus.success;
      notifyListeners();
      return [];
    }

  }

  /// returns IDs of all words that belongs to current user
  Future<List<int>> get wordsIds async {
    const String sql = 'SELECT ${DbConsts.colId} FROM ${DbConsts.tableWords} WHERE ${DbConsts.colWUserId} =?';
    try {
      // response should be a <List<Map>> [{'id': int}]
      final List<Map<String, dynamic>>? res = await _wordsRepository.rawQuery(sql, [_user.id]);
      if(res == null) return [];
      List ids = res.map((e) => e['id']).toList();
      // clean
      ids.removeWhere((element) => element is! int);
      List<int> intIDs = ids.map((e) => e as int).toList();
      return intIDs;
    } catch (e) {
      print('WordsProvider get wordsIds Error:\n$e');
      return [];
    }
  }



  Future<void> create(Word word) async {
    // replace the fake user id from form!
    Word newWithUserId = word.copyWith(userId: _user.id);
    print('WordsProvider create newWithUserId: $newWithUserId');
    _errorMsg = '';
    _status = WordsProviderStatus.loading;
    notifyListeners();
    try {
      final int res = await _wordsRepository.create(newWithUserId);
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
        _errorMsg = 'The word is not deleted!';
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

  Future<void> reverseIsFavorite(int id) async {
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
      final int? res = await _wordsRepository.rawUpdate([DbConsts.colWIsFavorite], [newFavValue], id);
      if (res == null) _errorMsg = 'The last change is not saved!';
    } catch (e) {
      _errorMsg = 'The last change is not saved! Try to restart the application';
      print(e);
    }
    _status = WordsProviderStatus.success;
    notifyListeners();
  }

  Future<void> update(Word item) async {
    _errorMsg = '';
    _status = WordsProviderStatus.loading;
    notifyListeners();
    try {
      final int res = await _wordsRepository.update(item);
      if (res == -1) _errorMsg = 'The last change is not saved!';
      if(res > 0) {
        final List<Word> newState =
        _words.take(_words.length).map((Word element) => element.id == item.id ? item : element).toList();
        _words = newState;
      }
    } catch (e) {
      _errorMsg = 'The last change is not saved! Try to restart the application';
      print(e);
    }
    _status = WordsProviderStatus.success;
    notifyListeners();
  }
}
