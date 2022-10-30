// ignore_for_file: avoid_print

import 'dart:async';

import 'package:davar/locator.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/domain/i_words_repository.dart';
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/foundation.dart';

class FilteredWordsProvider with ChangeNotifier {
  FilteredWordsProvider(this._user);

  final User _user;

  final IWordsRepository<Word> _wordsRepository = locator<IWordsRepository<Word>>();

  String _errorMsg = '';

  String get errorMsg => _errorMsg;

  set errorMsg(String value) {
    if (_errorMsg != value) {
      _errorMsg = value;
      notifyListeners();
    }
  }

  // AppConst.allCategoriesFilter id:0, name: 'all'
  WordCategory _selectedCategory = utils.AppConst.allCategoriesFilter;

  WordCategory get selected => _selectedCategory;

  void onCategoryChange(WordCategory? c) {
    if (c == null) _selectedCategory = utils.AppConst.allCategoriesFilter;
    if (c != _selectedCategory) {
      _selectedCategory = c!;
      print('onCategoryChange($c)');
      notifyListeners();
    }
  }

  bool _selectedOnlyFavorite = false;

  bool get selectedOnlyFavorite => _selectedOnlyFavorite;

  void onOnlyFavoriteChange() {
    _selectedOnlyFavorite = !_selectedOnlyFavorite;
    print('selectedOnlyFavorite: ($_selectedOnlyFavorite)');
    notifyListeners();
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

  // unsuccessful attempts to load more data. For diagnostic purpose!
  int _attemptsToLoadMore = 0;

  List<Word> _paginatedList = [];

  Stream<List<Word>?> filteredWordsStream() async* {
    await filter();
    yield _paginatedList;
  }

  // AppConst.allCategoriesFilter id:0, name: 'all'
  // if _selectedCategory == AppConst.allCategoriesFilter not add category filter to search query!
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
        // if it wal last response with data it may not be max query limit count
        // for eg data.length=2 and queryLimit=10, if then user will add new words (2 or 3),
        //the last added words may not be displayed because of listOffset!
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
