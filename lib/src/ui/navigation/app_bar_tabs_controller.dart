import 'package:flutter/foundation.dart';

class AppBarTabsController with ChangeNotifier {
  int _addScreenTabInitialIndex = 0;
  int _moreScreenTabInitialIndex = 0;
  int _schoolScreenTabInitialIndex = 0;
  int _youScreenTabInitialIndex = 0;

  int get addScreenTabInitialIndex => _addScreenTabInitialIndex;

  int get youScreenTabInitialIndex => _youScreenTabInitialIndex;

  int get schoolScreenTabInitialIndex => _schoolScreenTabInitialIndex;

  int get moreScreenTabInitialIndex => _moreScreenTabInitialIndex;

  void addScreenTabIndex(int value) {
    _addScreenTabInitialIndex = value;
    notifyListeners();
  }

  void youScreenTabIndex(int value) {
    _youScreenTabInitialIndex = value;
    notifyListeners();
  }

  void schoolScreenTabIndex(int value) {
    _schoolScreenTabInitialIndex = value;
    notifyListeners();
  }

  void moreScreenTabIndex(int value) {
    _moreScreenTabInitialIndex = value;
    notifyListeners();
  }
}
