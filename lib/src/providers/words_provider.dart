import 'package:davar/locator.dart';
import 'package:davar/src/data/local/database/db_consts.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/domain/i_words_repository.dart';
import 'package:flutter/foundation.dart';

enum WordsProviderStatus { error, loading, success }

class WordsProvider with ChangeNotifier {
  WordsProvider(this._user);

  final User _user;

  final IWordsRepository<Word> _wordsRepository = locator<IWordsRepository<Word>>();

  WordsProviderStatus _status = WordsProviderStatus.success;

  WordsProviderStatus get status => _status;

  String _errorMsg = '';

  String get wordsErrorMsg => _errorMsg;

  void confirmReadErrorMsg() {
    if (_errorMsg.isNotEmpty) {
      _errorMsg = '';
      notifyListeners();
    }
  }

  Future<List<Word>> readAllWords() async {
    _errorMsg = '';
    _status = WordsProviderStatus.loading;
    notifyListeners();
    try {
      final res = await _wordsRepository.readAll(_user.id);
      _status = WordsProviderStatus.success;
      notifyListeners();
      return res;
    } catch (e) {
      _status = WordsProviderStatus.success;
      notifyListeners();
      return [];
    }
  }

  Future<List<Word>> readPaginated({
    int offset = 0,
    List<String> where = const [],
    List<dynamic> whereValues = const [],
    int limit = 10,
  }) async {
    try {
      final List<Word> words = await _wordsRepository.readAllPaginated(
        userId: _user.id,
        offset: offset,
        limit: limit,
        where: where,
        whereValues: whereValues,
      );
      return words;
    } catch (e) {
      _errorMsg = 'Some thing has happened 🥴\n Data is unavailable';
      notifyListeners();
      return [];
    }
  }

  Future<List<Word>> rawQuerySearch(String queryString) async {
    try {
      final List<Map<String, dynamic>>? words =
          await _wordsRepository.rawQuery(queryString, [_user.id]);
      if (words != null && words.isNotEmpty) {
        return words.map((element) => Word.fromJson(element)).toList();
      }
      if (words != null && words.isEmpty) return [];
      _errorMsg = 'Data is unavailable!';
      notifyListeners();
      return [];
    } catch (e) {
      _errorMsg = 'Some thing has happened 🥴\n Data is unavailable';
      notifyListeners();
      return [];
    }
  }

  /// returns IDs of all words that belongs to current user
  Future<List<int>> get wordsIds async {
    const String sql =
        'SELECT ${DbConsts.colId} FROM ${DbConsts.tableWords} WHERE ${DbConsts.colWUserId} =?';
    try {
      // response should be a <List<Map>> [{'id': int}]
      final List<Map<String, dynamic>>? res = await _wordsRepository.rawQuery(sql, [_user.id]);
      if (res == null) return [];
      List ids = res.map((e) => e['id']).toList();
      // clean
      ids.removeWhere((element) => element is! int);
      List<int> intIDs = ids.map((e) => e as int).toList();
      return intIDs;
    } catch (e) {
      return [];
    }
  }

  Future<void> create(Word word) async {
    // replace the fake user id from form!
    Word newWithUserId = word.copyWith(userId: _user.id, points: 0);
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
      notifyListeners();
    } catch (e) {
      _errorMsg = 'Some thing has happened 🥴\n The word: ${word.catchword} is not created!';
      _status = WordsProviderStatus.error;
      notifyListeners();
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
      // await _fetchWords();
    } catch (e) {
      _errorMsg = 'Some thing has happened 🥴\n The word is not deleted!';
      _status = WordsProviderStatus.success;
      notifyListeners();
    }
    _errorMsg = '';
    _status = WordsProviderStatus.success;
    notifyListeners();
  }

  Future<void> reverseIsFavorite(Word item) async {
    // if word is favored isFavorite=1, else isFavorite=0
    _errorMsg = '';
    _status = WordsProviderStatus.loading;
    notifyListeners();
    final int newFavValue = item.isFavorite == 0 ? 1 : 0;
    try {
      final int? res =
          await _wordsRepository.rawUpdate([DbConsts.colWIsFavorite], [newFavValue], item.id);
      if (res == null) _errorMsg = 'The last change is not saved!';
    } catch (e) {
      _errorMsg = 'The last change is not saved. Try to restart the application';
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
    } catch (e) {
      _errorMsg = 'The last change is not saved! Try to restart the application';
    }
    _status = WordsProviderStatus.success;
    notifyListeners();
  }
}
