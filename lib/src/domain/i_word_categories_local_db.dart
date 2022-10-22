abstract class IWordCategoriesLocalDb<T> {
  Future<int> createWordCategory(T category);

  Future<List<T>> readAllWordCategory(int userId);

  /// returns single category or null
  Future<T?> readWordCategory(int id);

  Future<int> updateWordCategory(T category);

  Future<int> deleteWordCategory(int id);
}
