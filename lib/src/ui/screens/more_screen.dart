import 'package:davar/src/ui/navigation/navigation.dart';
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screen_base_with_scaffold_and_tab_bar.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({Key? key}) : super(key: key);
  static const routeName = '/more';
  static const String appBarTitle = 'More';
  static const List<Color> appBarGradientColors = [Colors.yellow, Colors.red];
  static const List<AppBarBottomTabModel> appBarBottomTabs = [
    AppBarBottomTabModel(Icons.settings_applications_outlined, 'Settings'),
    AppBarBottomTabModel(Icons.help_center_outlined, 'Help'),
    AppBarBottomTabModel(Icons.perm_device_info, 'About'),
  ];

  @override
  Widget build(BuildContext context) {
    return ScreenBaseWithScaffoldAndTabBar(
      key: const Key('MoreScreen-$routeName'),
      title: appBarTitle,
      appBarGradientColors: appBarGradientColors,
      appBarBottomTabs: appBarBottomTabs,
      bodyWidgets: const [
        Center(child: Text('Settings', style: TextStyle(fontSize: 28))),
        Center(child: Text('Help', style: TextStyle(fontSize: 28))),
        Center(child: Text('About', style: TextStyle(fontSize: 28))),
      ],
      tabControllerInitIndex: context.read<AppBarTabsController>().moreScreenTabInitialIndex,
      onTabIndexChange: (int value) =>
          context.read<AppBarTabsController>().moreScreenTabIndex(value),
    );
  }
}
