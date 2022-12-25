import 'package:davar/src/data/models/models.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConst {
  static const String appName = 'davar';
  static const int appVersionMajor = 1;
  static const int appVersionMinor = 0;
  static const int appVersionTiny = 0;
  static const int appVersionBuildNumber = 5;
git
  /// major.minor.tiny.build number
  static const String appVersionAsString =
      '$appVersionMajor.$appVersionMinor.$appVersionTiny.$appVersionBuildNumber';

  static final String developerEmail = dotenv.env['DEV_EMAIL_FOR_CONTACT'] ?? '@';

  ///User emptyUser = User(email: 'empty', id: 1, authToken: null);
  ///When user is unauthenticated.
  static const User emptyUser = User();

  ///User generated at the very beginning. When it is not know if user is authenticated.
  ///Generally when if it is application the first start.
  static const User unknownUser = User(
      authToken: null,
      createdAt: '-11111:-11:-11',
      email: 'unknown',
      id: -1,
      name: 'unknown');

  static const WordCategory allCategoriesFilter = WordCategory(id: 0, name: 'all', userId: 1);

  static const String statisticsQuizHighestScore = 'statistics_quiz_highest_score';
  static const String statisticsItemWithHighestPoints = 'statistics_item_highest_points';
  static const String statisticsItemWithLeastPoints = 'statistics_items_least_points';
  static const String statisticsSentencesQuantity = 'statistics_sentences_quantity';
  static const String statisticsWordsQuantity = 'statistics_words_quantity';
  static const String statisticsLastUpdateDate = 'statistics_last_update_date';
}
