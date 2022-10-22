abstract class IWordsLocalDb<T> {
  Future<int> createWord(T word);

  Future<List<T>> readAllWords(int userId);

  Future<T> readWord(int id);

  /// returns the number of changes made.
  Future<int> rawWordUpdate({
    required List<String> columns,
    required List<dynamic> values,
    required int wordId,
  });

  /// returns the number of changes made.
  Future<int> updateWord(T word);

  Future<int> deleteWord(int id);

  Future<List<T>> rawQueryWords(String query, List<dynamic> args);
}
