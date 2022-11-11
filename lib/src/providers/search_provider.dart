import 'package:davar/locator.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/domain/i_words_repository.dart';
import 'package:flutter/foundation.dart';

enum SearchProviderStatus { error, loading, success }

class SearchProvider with ChangeNotifier {
  SearchProvider(this._user);

  final User _user;

  final IWordsRepository<Word> _wordsRepository = locator<IWordsRepository<Word>>();

  SearchProviderStatus _status = SearchProviderStatus.success;

  SearchProviderStatus get status => _status;

  String _errorMsg = '';

  String get errorMsg => _errorMsg;

  set errorMsg(String value) {
    if (_errorMsg != value) {
      _errorMsg = value;
      notifyListeners();
    }
  }

  List<Word> _words = [];

  Future<List<Word>> get words async {
    if(_words.isNotEmpty) return _words;
    _words = await _wordsRepository.readAll(_user.id);
    return _words;
  }


  Future<void> delete(int id) async {
    print('delete(id=$id) -');
    _errorMsg = '';
    _status = SearchProviderStatus.loading;
    notifyListeners();
    try {
      // final int res = await _wordsRepository.delete(id);
      // if(res > 0) _words.removeWhere((element) => element.id == id);
      _words.removeWhere((element) => element.id == id);
      _status = SearchProviderStatus.success;
      notifyListeners();
    } catch (e) {
      _errorMsg = 'Some thing has happened 🥴\n The word was not deleted';
      notifyListeners();
      print(e);
    }
  }

  void updateState(Word item) {
    print('updateSingleWord(Word:\n $item)');
    try {
      _words = _words
          .take(_words.length)
          .map((Word e) => e.id == item.id ? item : e)
          .toList();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
