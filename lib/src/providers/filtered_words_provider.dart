// ignore_for_file: avoid_print

import 'dart:async';

import 'package:davar/locator.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/domain/i_words_repository.dart';
import 'package:flutter/foundation.dart';

// enum FilterWordProviderStatus { error, loading, success }

class FilteredWordsProvider with ChangeNotifier {
  FilteredWordsProvider(this._user);

  final User _user;

  final IWordsRepository<Word> _wordsRepository = locator<IWordsRepository<Word>>();

  // FilterWordProviderStatus _status = FilterWordProviderStatus.success;
  String _errorMsg = '';

  set errorMsg(String value) {
    if (_errorMsg != value) {
      _errorMsg = value;
      notifyListeners();
    }
  }

  List<Word> _paginatedList = [];

  //
  int _selectedCategoryId = -1;

  void onCategoryChange(int id) {
    if (id != _selectedCategoryId) {
      _selectedCategoryId = id;
      notifyListeners();
    }
  }

  int _selectedOnlyFavorite = 0;

  void onOnlyFavoriteChange(int val) {
    if (val != _selectedOnlyFavorite) {
      _selectedOnlyFavorite = val;
      notifyListeners();
    }
  }

  String _searchQueryString = '';

  void onSearchQueryStringChange(String val) {
    if (val != _searchQueryString) {
      _searchQueryString = val;
      notifyListeners();
    }
  }

  // pagination
  int _listOffset = 0;

  int get listOffset => _listOffset;

  set listOffset(int value) {
    _listOffset = value;
    notifyListeners();
  }

  // items per page (pagination)
  int _queryLimit = 2;

  int get queryLimit => _queryLimit;

  set queryLimit(int value) {
    _queryLimit = value;
    notifyListeners();
  }

  // count of items fetched at previews query
  int _prevFetchedItems = 0;

  int get prevFetchedItems => _prevFetchedItems;

  /// if previews query has less items (prevFetchedItems) then the limit (per page items count - queryLimit)
  /// it means that all was already loaded. There is no need to try to load more
  bool get isMoreItems => (_queryLimit <= _prevFetchedItems);

  String get errorMsg => _errorMsg;

  // unsuccessful attempts to load more data. For diagnostic purpose!
  int _attemptsToLoadMore = 0;

  Stream<List<Word>?> filteredWordsStream() async* {
    await filter();
    yield _paginatedList;
  }

  Future<List<Word>?> filter() async {
    print('FILTERED WORDS PROVIDER=>filter _listOffset= $_listOffset;');
    print('FILTERED WORDS PROVIDER=>filter _prevFetchedItems= $_prevFetchedItems');
    print('FILTERED WORDS PROVIDER=>filter isMoreItems= $isMoreItems;');
    print('FILTERED WORDS PROVIDER=>filter _attemptsToLoadMore= $_attemptsToLoadMore;');

    _attemptsToLoadMore++;
    notifyListeners();
    try {
      final List<Word> words = await _wordsRepository.readAllPaginatedById(
        userId: _user.id,
        offset: _listOffset,
        limit: _queryLimit,
      );
      // set the _prevFetchedItems and increment offset!
      _prevFetchedItems = words.length;
      // increment offset!
      if (words.length >= _queryLimit) {
        _listOffset = _listOffset + _queryLimit;
      } else {
        _listOffset = _listOffset + words.length;
      }
      if (words.isEmpty) return null;
      final List<Word> updatedState = [..._paginatedList, ...words];
      _attemptsToLoadMore = 0;
      _paginatedList = updatedState;
      notifyListeners();
      return _paginatedList;
    } catch (e) {
      _errorMsg = 'Some thing has happened 🥴\n Data is unavailable';
      notifyListeners();
      print(e);
      return null;
    }
  }
}
