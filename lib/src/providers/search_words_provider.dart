import 'dart:async';
import 'dart:collection';

import 'package:davar/src/data/local/database/db_consts.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/providers/providers.dart';
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/foundation.dart';

class SearchWordsProvider with ChangeNotifier {
  SearchWordsProvider(this._wp);

  final WordsProvider _wp;

  String _errorMsg = '';

  String get errorMsg => _errorMsg;

  void confirmReadErrorMsg() {
    if(_errorMsg.isNotEmpty) {
      _errorMsg = '';
      notifyListeners();
    }
  }

  // tests using this method:
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
    if (c == _selectedCategory) return;
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

  final _controller = StreamController<UnmodifiableListView<Word>>.broadcast();

  Stream<UnmodifiableListView<Word>> get filteredWords async* {
    yield UnmodifiableListView<Word>(_paginatedList);
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
    _controller.add(UnmodifiableListView<Word>(_paginatedList));
  }

  /// Mainly due to a change in list item, updates the list, without query to database.
  void updateState(Word item) {
    _paginatedList = _paginatedList
        .take(_paginatedList.length)
        .map((Word e) => e.id == item.id ? item : e)
        .toList();
    notifyListeners();
    _controller.add(UnmodifiableListView<Word>(_paginatedList));
  }

  /// insert items at the top of the list of current displaying items
  void insertItemAtTheTop(Word item) {
    // if _paginatedList already contains the item - move it at the beginning
    // else add found item at the beginning
    _paginatedList.removeWhere((e) => e.id == item.id);
    _paginatedList.insert(0, item);
    _controller.add(UnmodifiableListView<Word>(_paginatedList));
  }

  /// Handle Search Delegate
  Stream<UnmodifiableListView<Word>> querySearch(String query) async* {
    List<Word> res = await searchQuery(query);
    yield UnmodifiableListView<Word>(res);
  }

  Future<List<Word>> searchQuery(String queryValue) async {
    _clearErrorMsg();
    final String likeString = prepareLikeSql(queryValue);
    try {
      final String sql = '${DbConsts.selectAllFromTableWords} $likeString';
      final List<Word> words = await _wp.rawQuerySearch(sql);
      return words;
    } catch (e) {
      if (kDebugMode) print('SearchWordsProvider searchQuery ERROR:\n $e');
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
      _controller.add(UnmodifiableListView<Word>(_paginatedList));
    } catch (e) {
      _errorMsg = 'Some thing has happened 🥴\n Data is unavailable';
      notifyListeners();
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
      final List<Word> words = await _wp.readPaginated(
        offset: offset,
        limit: limit,
        where: where,
        whereValues: args,
      );
      return words;
    } catch (e) {
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
      await _wp.delete(id);
      _paginatedList.removeWhere((element) => element.id == id);
      _listOffset = _listOffset - 1;
      notifyListeners();
      _controller.add(UnmodifiableListView<Word>(_paginatedList));
    } catch (e) {
      _errorMsg = 'Some thing has happened 🥴\n The word was not deleted';
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(Word i) async {
    final int value = i.isFavorite == 1 ? 0 : 1;
    try {
      await _wp.reverseIsFavorite(i);
      _paginatedList =
          _paginatedList.map((e) => e.id == i.id ? e.copyWith(isFavorite: value) : e).toList();
      notifyListeners();
      _controller.add(UnmodifiableListView<Word>(_paginatedList));
    } catch (e) {
      _errorMsg = 'Some thing has happened 🥴\n Changes not saved';
      notifyListeners();
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
    await _controller.close();
  }
}
