import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../navigation/navigation.dart';
import 'screen_base_with_scaffold_and_tab_bar.dart';

class YouScreen extends StatelessWidget {
  const YouScreen({Key? key}) : super(key: key);
  static const routeName = '/you';
  static const String appBarTitle = 'You';
  static const List<Color> appBarGradientColors = [Colors.orange, Colors.purple];
  static const List<AppBarBottomTabModel> appBarBottomTabs = [
    AppBarBottomTabModel(Icons.dashboard_customize_outlined, 'Customize'),
    AppBarBottomTabModel(Icons.face_outlined, 'Profile'),
    AppBarBottomTabModel(Icons.backup_outlined, 'Backup'),
  ];

  @override
  Widget build(BuildContext context) {
    return ScreenBaseWithScaffoldAndTabBar(
      key: const Key('YouScreen-$routeName'),
      title: appBarTitle,
      appBarGradientColors: appBarGradientColors,
      appBarBottomTabs: appBarBottomTabs,
      bodyWidgets: const [
        Center(child: Text('Settings', style: TextStyle(fontSize: 28))),
        Center(child: Text('Help', style: TextStyle(fontSize: 28))),
        Center(child: Text('About', style: TextStyle(fontSize: 28))),
      ],
      tabControllerInitIndex: context.read<AppBarTabsController>().youScreenTabInitialIndex,
      onTabIndexChange: (int value) =>
          context.read<AppBarTabsController>().youScreenTabIndex(value),
    );
  }
}
