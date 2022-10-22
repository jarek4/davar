// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ErrorsReporter {
 //  late Sentry sentry;

  static Future<void> setup(Widget child) async {
    await SentryFlutter.init(
      (options) {
        options.dsn = 'SENTRY_DNS';
        // options.dsn = dotenv.env['SENTRY_DNS'];
        // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
        // We recommend adjusting this value in production.
        // options.tracesSampleRate = 1.0;
        options.reportPackages = false;
        options.considerInAppFramesByDefault = false;
      },
      appRunner: () => runApp(
        DefaultAssetBundle(
          bundle: SentryAssetBundle(
            // enableStructuredDataTracing: true,
          ),
          child: child,
        ),
      ),
    );
  }

  static genericThrow(String message, Exception exc, {stackTrace}) async {
    if (stackTrace != null) {
      // Sentry.captureException(exc, stackTrace: stackTrace);
      print('genericThrow stackTrace');
    } else {
      // Sentry.captureException(exc);
      print('genericThrow ');
    }
  }
}
