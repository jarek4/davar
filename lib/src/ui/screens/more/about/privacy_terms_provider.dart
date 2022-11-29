import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;


class PrivacyTermsProvider with ChangeNotifier {

  static const String _privacyPolicyInit = 'Privacy Policy\nLast updated: December 8, 2022';
  String get privacyPolicyInit => _privacyPolicyInit;

  Future<String> readPrivacyPolicy() async {
   try {
     final String res = await rootBundle.loadString(utils.AssetsPath.txtPrivacyStatement);
     await Future.delayed(const Duration(seconds: 1));
     return res;
   } catch (e) {
     if (kDebugMode) print(e);
     return '';
   }
  }

  Future<String> readTermsStatement() async {
    try {
      final String res = await rootBundle.loadString(utils.AssetsPath.txtTermsOfUse);
      await Future.delayed(const Duration(seconds: 1));
      return res;
    } catch (e) {
      if (kDebugMode) print(e);
      return '';
    }
  }

}