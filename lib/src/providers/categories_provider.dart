import 'package:davar/locator.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/domain/i_word_categories_repository.dart';
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

  List<WordCategory> get categories => _categories;

  List<String> get categoriesNames => _categories.map((e) => e.name).toList();

  // List<String> get categoriesNames => ['no category', 'animals', 'people'];

  Future<void> create() async {
    _status = CategoriesProviderStatus.loading;
    notifyListeners();
    // Map<String, dynamic> cat = {'id': -1, 'name': 'testCategory', 'userId': 2};
    int response =
        await _categoriesRepository.create(const WordCategory(id: 32, name: 'cat no.5', userId: 1));
    print('CategoriesProvider-create created id: $response');
    await _fetchCategories();
  }

  Future<void> update() async {
    _status = CategoriesProviderStatus.loading;
    notifyListeners();
    const WordCategory w = WordCategory(id: 1, name: 'updated4', userId: 1);
    await _categoriesRepository.update(w);
    await _fetchCategories();
  }
  Future<void> delete(int id) async {
    _status = CategoriesProviderStatus.loading;
    notifyListeners();
    const WordCategory w = WordCategory(id: 1, name: 'updated4', userId: 1);
    await _categoriesRepository.update(w);
    await _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    _status = CategoriesProviderStatus.loading;
    notifyListeners();
    _categories = await _categoriesRepository.readAll(_user.id);
    _status = CategoriesProviderStatus.success;
    notifyListeners();
  }
}
