abstract class IWordCategoriesRepository<T> {
  /// Returns created item id. -1 if already exists, 0 if conflict
  /// not longer then 20 characters!
  Future<int> create(T category);

  /// returns list of categories belongs to the user
  Future<List<T>> readAll(int userId);

  Future<T?> read(int id);

  /// Returns the number of changes made. -1 on error
  /// not longer then 20 characters!
  Future<int> update(T category);

  ///Returns the number of rows affected.
  Future<int> delete(int id);
}
