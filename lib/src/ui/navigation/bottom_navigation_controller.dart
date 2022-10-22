import 'package:flutter/foundation.dart';

class BottomNavigationController extends ChangeNotifier {

  String _route = '/school';
  int _selectedIndex = 0;

  String get route => _route;
  int get selectedIndex => _selectedIndex;

  void onScreenChange(String routeName, { int? index }) {
    _route = routeName;
    if(index != null) _selectedIndex = index;
    notifyListeners();
  }
  void resetBottomNavigation() {
    _route = '/school';
    _selectedIndex = 0;
  }

}
