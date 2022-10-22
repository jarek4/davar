import 'package:davar/src/data/models/models.dart';

class AppConst {
  static const int appVersionMajor = 0;
  static const int appVersionMinor = 0;
  static const int appVersionTiny = 1;
  static const int appVersionBuildNumber = 1;

  /// major.minor.tiny.build number
  static const String appVersionAsString =
      '$appVersionMajor.$appVersionMinor.$appVersionTiny.$appVersionBuildNumber';

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
}
