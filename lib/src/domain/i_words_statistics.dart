abstract class IWordsStatistics {
  Future<bool> saveItemWithHighestPoints(List<String> item);

  /// <String>['catchword', 'points', 'id']
  Future<List<String>> readItemWithHighestPoints();

  Future<bool> saveItemWithLowestPoints(List<String> item);

  /// <String>['catchword', 'points', 'id']
  Future<List<String>> readItemWithLowestPoints();

  Future<bool> saveWordsQuantity( int value);
  Future<int> readWordsQuantity();
  Future<bool> saveSentencesQuantity( int value);
  Future<int> readSentencesQuantity();
  Future<bool> saveUpdateDate(String date);
  Future<String> readUpdateDate();

}
