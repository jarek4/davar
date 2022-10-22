abstract class IWordsRepository<T> {
  Future<int> create(T item);

  Future<List<T>> readAll(int userId);

  Future<List<T>> rawQuery(String query, List<dynamic> arguments);

  Future<int> update(T item);

  Future<int> rawUpdate(List<String> columns, List<dynamic> arguments, int wordId);

  Future<int> delete(int itemId);
}