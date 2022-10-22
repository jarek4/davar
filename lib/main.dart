import 'package:davar/src/errors_reporter/errors_reporter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'locator.dart';
import 'src/app.dart';
import 'src/settings/settings_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  setupLocator();
  final settingsController = SettingsController();
  await settingsController.loadSettings();
  await ErrorsReporter.setup(DavarApp(settingsController: settingsController));
}
