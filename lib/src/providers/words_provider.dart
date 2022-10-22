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

  WordsProviderStatus get status => _status;

  List<Word> get words => _words;

  Future<void> delete(int id) async {
    final List<Word> resp = await _wordsRepository.readAll(1);
  }

  Future<void> triggerFavorite(int id) async {
    final List<Word> resp = await _wordsRepository.readAll(1);
  }

  Future<void> _fetchWords() async {
    _status = WordsProviderStatus.loading;
    notifyListeners();
    _words = await _wordsRepository.readAll(1); // _user.id
    _status = WordsProviderStatus.success;
    notifyListeners();
  }
}
