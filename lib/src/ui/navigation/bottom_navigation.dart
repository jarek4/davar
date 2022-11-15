import 'package:davar/src/ui/screens/add/add_screen.dart';
import 'package:davar/src/ui/screens/more/more_screen.dart';
import 'package:davar/src/ui/screens/school/school_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'bottom_navigation_controller.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  String _getRouteName(int index) {
    switch (index) {
      case (0):
        return SchoolScreen.routeName;
      case (1):
        return AddScreen.routeName;
      case (2):
        return MoreScreen.routeName;
      default:
        return SchoolScreen.routeName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0.7,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'School',
          tooltip: 'Words list, quiz, statistics',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Add',
          tooltip: 'Add new word or sentence',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.more_horiz_rounded),
          label: 'More',
          tooltip: 'Profile, settings, about',
        ),
      ],
      showUnselectedLabels: true,
      currentIndex: Provider.of<BottomNavigationController>(context).selectedIndex,
      selectedItemColor: Colors.amber[800],
      unselectedItemColor: Colors.grey,
      onTap: (index) => context
          .read<BottomNavigationController>()
          .onScreenChange(_getRouteName(index), index: index),
    );
  }
}
