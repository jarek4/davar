import 'package:davar/src/davar_ads/davar_ads.dart';
import 'package:davar/src/errors_reporter/errors_reporter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'locator.dart';
import 'src/app.dart';
import 'src/settings/settings_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  setupLocator();
  final settingsController = SettingsController();
  await settingsController.loadSettings();
  final String testDeviceId = dotenv.env['ADMOB_TEST_DEVICE_ID'] ?? '';
  RequestConfiguration configuration = RequestConfiguration(testDeviceIds: [testDeviceId]);
  final Future<InitializationStatus> initFuture = MobileAds.instance.initialize();
  MobileAds.instance.updateRequestConfiguration(configuration);
  await ErrorsReporter.setup(Provider<AdState>.value(
      value: AdState(initFuture), child: DavarApp(settingsController: settingsController)));
  // DavarApp(settingsController: settingsController);
}
