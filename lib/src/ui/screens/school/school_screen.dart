import 'package:davar/src/ui/screens/school/school.dart';
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../navigation/navigation.dart';
import '../screen_base_with_scaffold_and_tab_bar.dart';

class SchoolScreen extends StatelessWidget {
  const SchoolScreen({Key? key}) : super(key: key);
  static const routeName = '/school';
  static const List<Color> appBarGradientColors = [Colors.purple, Colors.red];
  static const List<AppBarBottomTabModel> appBarBottomTabs = [
    AppBarBottomTabModel(Icons.list_alt, 'All words'),
    AppBarBottomTabModel(Icons.quiz_outlined, 'Quiz'),
    AppBarBottomTabModel(Icons.query_stats_rounded, 'Statistics'),
  ];
  static const List<Widget> bodyWidgets = [
    WordsListScreen(),
    QuizScreen(),
    StatisticsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final int initIndex =
        Provider.of<AppBarTabsController>(context, listen: false).schoolScreenTabInitialIndex;
    return ScreenBaseWithScaffoldAndTabBar(
      key: const Key('SchoolScreen-$routeName'),
      appBarGradientColors: appBarGradientColors,
      appBarBottomTabs: appBarBottomTabs,
      bodyWidgets: bodyWidgets,
      tabControllerInitIndex: initIndex,
      onTabIndexChange: (int value) =>
          context.read<AppBarTabsController>().schoolScreenTabIndex(value),
    );
  }
}
