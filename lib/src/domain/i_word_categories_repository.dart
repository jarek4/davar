abstract class IWordCategoriesRepository<T> {
  Future<int> create(T category);

  Future<List<T>> readAll(int userId);

  Future<T?> read(int id);

  Future<int> update(T category);

  Future<int> delete(int id);
}
