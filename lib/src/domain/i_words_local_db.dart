abstract class IWordsLocalDb<T> {
  /// Returns the id of the last inserted row. 0 if conflict
  Future<int> createWord(T word);

  Future<List<T>> readAllWords(int userId);

  /// returns single word or null
  Future<T> readWord(int id);

  /// returns the number of changes made.
  Future<int> rawWordUpdate({
    required List<String> columns,
    required List<dynamic> values,
    required int wordId,
  });

  /// returns the number of changes made.
  Future<int> updateWord(T word);

  /// Returns the number of rows affected. -1 on error
  Future<int> deleteWord(int id);

  Future<List<T>> rawQueryWords(String query, List<dynamic> args);
}
