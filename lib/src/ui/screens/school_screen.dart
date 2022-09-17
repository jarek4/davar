import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../navigation/navigation.dart';
import 'screen_base_with_scaffold_and_tab_bar.dart';

class SchoolScreen extends StatelessWidget {
  const SchoolScreen({Key? key}) : super(key: key);
  static const routeName = '/school';
  static const String appBarTitle = 'School';
  static const List<Color> appBarGradientColors = [Colors.purple, Colors.red];
  static const List<AppBarBottomTabModel> appBarBottomTabs = [
    AppBarBottomTabModel(Icons.list_alt, 'All words'),
    AppBarBottomTabModel(Icons.quiz_outlined, 'Quiz'),
    AppBarBottomTabModel(Icons.query_stats_rounded, 'Statistics'),
  ];
  static const List<Widget> bodyWidgets = [
    Center(child: Text('All your words2', style: TextStyle(fontSize: 28))),
    Center(child: Text('Quiz2', style: TextStyle(fontSize: 28))),
    Center(child: Text('Your statistics2', style: TextStyle(fontSize: 28))),
  ];

  @override
  Widget build(BuildContext context) {
    return ScreenBaseWithScaffoldAndTabBar(
      key: const Key('SchoolScreen-$routeName'),
      title: appBarTitle,
      appBarGradientColors: appBarGradientColors,
      appBarBottomTabs: appBarBottomTabs,
      bodyWidgets: bodyWidgets,
      tabControllerInitIndex: context.read<AppBarTabsController>().schoolScreenTabInitialIndex,
      onTabIndexChange: (int value) =>
          context.read<AppBarTabsController>().schoolScreenTabIndex(value),
    );
  }
}
