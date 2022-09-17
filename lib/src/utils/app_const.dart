import 'package:davar/src/data/models/models.dart';

class AppConst {
  static const int appVersionMajor = 0;
  static const int appVersionMinor = 0;
  static const int appVersionTiny = 1;
  static const int appVersionBuildNumber = 1;
  static const String appVersionAsString =
      '$appVersionMajor.$appVersionMinor.$appVersionTiny.$appVersionBuildNumber';
  static const User emptyUser = User(email: 'empty', id: -1, authToken: null);
}
