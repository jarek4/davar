// ignore_for_file: avoid_print

import 'dart:async';

import 'package:davar/locator.dart';
import 'package:davar/src/data/local/database/db_consts.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/domain/i_words_repository.dart';
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/foundation.dart';

class SearchWordsProvider with ChangeNotifier {
  SearchWordsProvider(this._user);

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

  WordCategory get selectedCategory => _selectedCategory;

  Future<void> onCategoryChange(WordCategory? c) async {
    if(c == _selectedCategory) return;
    if (c == null) {
      _selectedCategory = utils.AppConst.allCategoriesFilter;
    } else {
      _selectedCategory = c;
    }
    final limit = _paginatedList.length < _queryLimit ? _queryLimit : _paginatedList.length;
    _listOffset = 0;
    notifyListeners();
    await updateStream(limit: limit);
  }

  bool _selectedOnlyFavorite = false;

  bool get selectedOnlyFavorite => _selectedOnlyFavorite;

  Future<void> onOnlyFavoriteChange() async {
    _selectedOnlyFavorite = !_selectedOnlyFavorite;
    final limit = _paginatedList.length < _queryLimit ? _queryLimit : _paginatedList.length;
    _listOffset = 0;
    notifyListeners();
    // read from database with current filters. Limit is actual number of items in list.
    await updateStream(limit: limit);
  }

  // pagination
  int _listOffset = 0;

  int get listOffset => _listOffset;

  set listOffset(int value) {
    _listOffset = value;
    notifyListeners();
  }

  // items per single fetch query (pagination)
  int _queryLimit = 3;

  int get queryLimit => _queryLimit;

  set queryLimit(int value) {
    _queryLimit = value;
    notifyListeners();
  }

  int _prevFetchedItems = 0;

  /// Count of items fetched at previews query. Helps to to determine if there are still items to fetch
  int get prevFetchedItems => _prevFetchedItems;

  /// if previews query has less items (prevFetchedItems) then the limit (per page items count - queryLimit)
  /// it means that all was already loaded. There is no need to try to load more
  bool get isMoreItems => (_queryLimit <= _prevFetchedItems);

  // Stores the currently displayed items
  List<Word> _paginatedList = [];

  final _controller = StreamController<List<Word>>.broadcast();

  Stream<List<Word>> get filteredWords async* {
    yield _paginatedList;
    yield* _controller.stream;
  }

  /// Retrieves from DB without offset and regard to the filters set. Mainly due to a change in list item.
  Future<void> updateStream({int? limit}) async {
    final int newLimit = _paginatedList.length > _queryLimit ? _paginatedList.length : _queryLimit;
    _clearErrorMsg();
    List<Word> res = await _fetch(offset: 0, limit: limit ?? newLimit);
    _prevFetchedItems = res.length;
    // increment offset!
    _listOffset = res.length;
    // _incrementListOffset(res.length); don't do that! it will skip _queryLimit number items
    _paginatedList = res;
    notifyListeners();
    _controller.add(_paginatedList);
  }

  /// Mainly due to a change in list item, updates the list, without query to database.
  void updateState(Word item) {
    print('Provider updateState(Word:\n ${item.catchword})');
    try {
      _paginatedList = _paginatedList
          .take(_paginatedList.length)
          .map((Word e) => e.id == item.id ? item : e)
          .toList();
      notifyListeners();
      _controller.add(_paginatedList);
    } catch (e) {
      print(e);
    }
  }

  /// insert items at the top of the list of current displaying items
  void insertItemAtTheTop(Word item) {
      print('updateWithFound 1 element: ${item.catchword}');
      // if _paginatedList already contains the item - move it at the beginning
      // else add found item at the beginning
      _paginatedList.removeWhere((e) => e.id == item.id);
      _paginatedList.insert(0, item);
    _controller.add(_paginatedList);
  }

  /// Handle Search Delegate
  Stream<List<Word>> querySearch(String query) async* {
    List<Word> res = await searchQuery(query);
    yield res;
  }

  Future<List<Word>> searchQuery(String queryValue) async {
    _clearErrorMsg();
    final String likeString = prepareLikeSql(queryValue);
    try {
      final String sql = '${DbConsts.selectAllFromTableWords} $likeString';
      // final List<Word>? words = await _wordsRepository.rawQuery(sql, [_user.id]);
      final List<Map<String, dynamic>>? words = await _wordsRepository.rawQuery(sql, [_user.id]);
      if (words != null) return words.map((element) => Word.fromJson(element)).toList();
      _errorMsg = 'Data is unavailable. Some error has happened, sorry!';
      notifyListeners();
      return [];
    } catch (e) {
      print('FilteredWordsProvider searchQuery ERROR:\n $e');
      _errorMsg = 'Some thing has happened 🥴\n Data is unavailable';
      notifyListeners();
      return [];
    }
  }

  String prepareLikeSql(String like) {
    String likeString = " AND ${DbConsts.colWCatchword} LIKE '%$like%'";
    if (like.isEmpty) {
      likeString = " AND ${DbConsts.colWCatchword} LIKE '%'";
    }
    return likeString;
  }

  Future<void> filter({int offset = 0}) async {
    _clearErrorMsg();
    List<Word> tempList = [];
    try {
      final List<Word> res = await _fetch(offset: _listOffset, limit: _queryLimit);
      _prevFetchedItems = res.length;
      // _incrementListOffset(res.length);
      if (res.isEmpty) return;
      tempList = [..._paginatedList, ...res];
      _paginatedList = _removeDuplicates(tempList);
      _incrementListOffset(res.length);
      notifyListeners();
      _controller.add(_paginatedList);
    } catch (e) {
      _errorMsg = 'Some thing has happened 🥴\n Data is unavailable';
      notifyListeners();
      print(e);
    }
  }

  // AppConst.allCategoriesFilter id:0, name: 'all'
  // if _selectedCategory == AppConst.allCategoriesFilter don't add category filter to search query!
  // if any filter has changed first need to empty _paginatedList!
  Future<List<Word>> _fetch({int offset = 0, int limit = 2}) async {
    List<String> where = [];
    List<dynamic> args = [];
    // id=0 for 'all categories';
    if (_selectedCategory.id > 0) {
      // onCategoryChange will set _listOffset = 0.
      where.add(DbConsts.colWCategoryId);
      args.add(_selectedCategory.id);
    }
    if (_selectedOnlyFavorite) {
      // onOnlyFavoriteChange will set _listOffset = 0.
      where.add(DbConsts.colWIsFavorite);
      args.add(1);
    }
    try {
      final List<Word> words = await _wordsRepository.readAllPaginated(
        userId: _user.id,
        offset: offset,
        limit: limit,
        where: where,
        whereValues: args,
      );
      return words;
    } catch (e) {
      print('FilteredWordsProvider fetch ERROR:\n $e');
      _errorMsg = 'Some thing has happened 🥴\n Data is unavailable';
      notifyListeners();
      return [];
    }
  }

  List<Word> _removeDuplicates(List<Word> items) {
    List<Word> uniqueItems = [];
    final Set<int> uniqueIDs = items.map((e) => e.id).toSet(); //remove duplicates
    for (int uID in uniqueIDs) {
      uniqueItems.add(items.firstWhere((i) => i.id == uID));
    } // populate uniqueItems with equivalent from original items
    return uniqueItems; //the unique items list
  }

  void _incrementListOffset(int fetchedItemsCount) {
    if (fetchedItemsCount >= _queryLimit) {
      _listOffset = _listOffset + _queryLimit;
    } else {
      // if it was last response with data it may not be max query limit count
      // for eg data.length=2 and queryLimit=10, if then user will add new words (2 or 3),
      //the last added words may not be fetched and displayed because of listOffset!
      _listOffset = _listOffset + fetchedItemsCount;
    }
  }

  Future<void> delete(int id) async {
    _clearErrorMsg();
    try {
      final int res = await _wordsRepository.delete(id);
      if (res < 1) {
        _errorMsg = 'The word was not deleted';
        notifyListeners();
        return;
      }
      _paginatedList.removeWhere((element) => element.id == id);
      _listOffset = _listOffset - 1;
      notifyListeners();
      _controller.add(_paginatedList);
    } catch (e) {
      _errorMsg = 'Some thing has happened 🥴\n The word was not deleted';
      notifyListeners();
      print(e);
    }
  }

  Future<void> toggleFavorite(Word i) async {
    final int value = i.isFavorite == 1 ? 0 : 1;
    try {
      final int? res = await _wordsRepository.rawUpdate([DbConsts.colWIsFavorite], [value], i.id);
      if (res == null || res < 1) {
        _errorMsg = 'The word was not deleted';
        notifyListeners();
        return;
      }
      _paginatedList =
          _paginatedList.map((e) => e.id == i.id ? e.copyWith(isFavorite: value) : e).toList();
      notifyListeners();
      _controller.add(_paginatedList);
    } catch (e) {
      _errorMsg = 'Some thing has happened 🥴\n The word was not deleted';
      notifyListeners();
      print(e);
    }
  }

  void _clearErrorMsg() {
    if (_errorMsg.isNotEmpty) {
      _errorMsg = '';
      notifyListeners();
    }
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    _listOffset = 0;
    _prevFetchedItems = 0;
    await _controller.close().then((value) => print('_controller is closed'));
  }
}
