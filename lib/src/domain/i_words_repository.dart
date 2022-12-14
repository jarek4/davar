abstract class IWordsRepository<T> {
  /// Returns created item id. -1 if error,  0 if conflict
  Future<int> create(T item);

  Future<List<T>> readAll(int userId);

  Future<T?> readSingle(int id);

  /// 'WHERE words_table.userId=? AND words_table.categoryId=? AND like LIKE '%likeValue%''
  Future<List<T>> readAllPaginated({
    required int userId,
    required int offset,
    List<String> where = const [],
    List<dynamic> whereValues = const [],
    String? like,
    dynamic likeValue,
    int limit = 10,
  });

  ///Null if error. If not reading all columns - be aware when do Word.fromJson()!
  Future<List<Map<String, dynamic>>?> rawQuery(String query, List<dynamic> arguments);

  /// returns the number of changes made.  -1 on error
  Future<int> update(T item);

  /// returns the number of changes made. Null if error
  Future<int?> rawUpdate(List<String> columns, List<dynamic> arguments, int wordId);

  /// Returns the number of rows affected. -1 on error
  Future<int> delete(int itemId);
}
