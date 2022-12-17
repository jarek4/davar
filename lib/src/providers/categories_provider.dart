import 'dart:collection';

import 'package:davar/locator.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/domain/i_word_categories_repository.dart';
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/foundation.dart';

enum CategoriesProviderStatus { error, loading, success }

class CategoriesProvider with ChangeNotifier {
  CategoriesProvider(this._user) {
    _fetchCategories();
  }

  final IWordCategoriesRepository<WordCategory> _categoriesRepository =
      locator<IWordCategoriesRepository<WordCategory>>();

  final User _user;
  CategoriesProviderStatus _status = CategoriesProviderStatus.loading;

  CategoriesProviderStatus get status => _status;

  List<WordCategory> _categories = [];

  /// do not use this to create search by WordCategories! Use filterCategories.
  // List<WordCategory> get categories => _categories;
  UnmodifiableListView<WordCategory> get categories => UnmodifiableListView(_categories);

  /// use this to create search by WordCategories. Contains AppConst.allCategoriesFilter id:0, name: 'all'.
  UnmodifiableListView<WordCategory> get filterCategories =>
      UnmodifiableListView([utils.AppConst.allCategoriesFilter, ..._categories]);

  UnmodifiableListView<String> get categoriesNames =>
      UnmodifiableListView(_categories.map((e) => e.name).toList());

  String _errorMsg = '';

  String get categoriesErrorMsg => _errorMsg;

  String _newCategoryName = '';

  String get newCategoryName => _newCategoryName;

  void onNewCategoryNameChange(String value) {
    if (_newCategoryName != value) {
      _newCategoryName = value;
    }
  }

  // not longer then 20 characters!
  Future<void> create() async {
    _status = CategoriesProviderStatus.loading;
    notifyListeners();
    final WordCategory created = WordCategory(id: -1, userId: _user.id, name: _newCategoryName);
    try {
      final int response = await _categoriesRepository.create(created);
      // this category already exists
      if (response == -1) {
        _errorMsg = 'Category: ${created.name} already exists!';
        _status = CategoriesProviderStatus.success;
        notifyListeners();
        return;
      }
      // category successfully created
      _fetchCategories();
    } catch (e) {
      _errorMsg = 'The category: ${created.name} was not created!';
      _status = CategoriesProviderStatus.error;
      notifyListeners();
    }
  }

  // not longer then 20 characters!
  Future<void> update(WordCategory category) async {
    _status = CategoriesProviderStatus.loading;
    notifyListeners();
    final WordCategory toUpdate = category.copyWith(userId: _user.id, name: _newCategoryName);
    try {
      final int res = await _categoriesRepository.update(toUpdate);
      if (res == -1) {
        _errorMsg = 'The last category change was not saved!';
        _status = CategoriesProviderStatus.success;
        notifyListeners();
        return;
      }
      final WordCategory? updated = await _categoriesRepository.read(category.id);
      if (updated != null) {
        final List<WordCategory> newState =
            _categories.map((e) => e.id == updated.id ? updated : e).toList();
        _categories = newState;
        _status = CategoriesProviderStatus.success;
        _errorMsg = '';
        notifyListeners();
        return;
      }
      _status = CategoriesProviderStatus.success;
      _errorMsg = 'It looks like the last changes was not saved.';
      notifyListeners();
      // await _fetchCategories();
    } catch (e) {
      _errorMsg = 'The last category change was not saved!';
      _status = CategoriesProviderStatus.error;
      notifyListeners();
    }
  }

  Future<void> delete(int id) async {
    _status = CategoriesProviderStatus.loading;
    notifyListeners();
    try {
      final int res = await _categoriesRepository.delete(id);
      if (res < 1) {
        _errorMsg = 'The category change was not deleted!';
        _status = CategoriesProviderStatus.success;
        notifyListeners();
        return;
      }
      await _fetchCategories();
    } catch (e) {
      _errorMsg = 'The category change was not deleted!';
      _status = CategoriesProviderStatus.error;
      notifyListeners();
    }
  }

  Future<void> _fetchCategories() async {
    _errorMsg = '';
    _status = CategoriesProviderStatus.loading;
    notifyListeners();
    try {
      _categories = await _categoriesRepository.readAll(_user.id);
      _status = CategoriesProviderStatus.success;
      notifyListeners();
    } catch (e) {
      _errorMsg = 'Some thing bad has happened 🥴\n Try to restart the application';
      _status = CategoriesProviderStatus.error;
      notifyListeners();
    }
  }
}
