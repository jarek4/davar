import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {
  AdState(this.initialization);

  Future<InitializationStatus> initialization;

  // test ad units
  static const String _androidTest = 'ca-app-pub-3940256099942544/6300978111';
  static const String _iosTest = 'ca-app-pub-3940256099942544/2934735716';
 /* static final String _testDeviceId = dotenv.env['ADMOB_TEST_DEVICE_ID'] ?? '';

   RequestConfiguration configuration =
  RequestConfiguration(testDeviceIds: [_testDeviceId]);*/

  // Davar app ad units
  final String _androidBannerAdUnitId =
      dotenv.env['ADMOB_ANDROID_BANNER_UNIT_1_ID'] ?? _androidTest;
  final String _iosBannerAdUnitId = dotenv.env['ADMOB_IOS_BANNER_UNIT_1_ID'] ?? _iosTest;

  String get bannerAdUnitId => Platform.isAndroid ? _androidTest : _iosTest;
}
