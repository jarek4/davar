import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {
  AdState(this.initialization);

  Future<InitializationStatus> initialization;

  // test ad units
  static const String _androidTest = 'ca-app-pub-3940256099942544/6300978111';
  static const String _iosTest = 'ca-app-pub-3940256099942544/2934735716';

  // Davar app ad units
  final String _androidBannerAdUnitId =
      dotenv.env['ADMOB_ANDROID_BANNER_UNIT_1_ID'] ?? _androidTest;
  final String _iosBannerAdUnitId = dotenv.env['ADMOB_IOS_BANNER_UNIT_1_ID'] ?? _iosTest;

  String get bannerAdUnitId => Platform.isAndroid ? _androidTest : _iosTest;

/*  BannerAdListener get adListener => _adListener;

  final BannerAdListener _adListener = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('BannerAdListener Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();
      print('BannerAdListener Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('BannerAdListener Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('BannerAdListener Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => print('BannerAdListener Ad impression.'),
  );*/

}
