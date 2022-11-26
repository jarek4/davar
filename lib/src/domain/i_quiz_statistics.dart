abstract class IQuizStatistics {
  Future<bool> saveHighestQuizScore(int value);
  Future<int> readHighestQuizScore();
}
