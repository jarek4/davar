abstract class IWordCategoriesLocalDb<T> {
  /// Returns created item id. -1 if already exists, 0 if conflict
  Future<int> createWordCategory(T category);

  Future<List<T>> readAllWordCategory(int userId);

  /// returns single category or null
  Future<T?> readWordCategory(int id);

  /// Returns the number of changes made
  Future<int> updateWordCategory(T category);

  /// Returns the number of rows affected. -1 on error
  Future<int> deleteWordCategory(int id);
}
