import 'package:davar/src/errors_reporter/errors_reporter.dart';
import 'package:davar/src/ui/navigation/navigation.dart';
import 'package:davar/src/ui/screens/more/more.dart';
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screen_base_with_scaffold_and_tab_bar.dart';

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
    final int initIndex =
        Provider.of<AppBarTabsController>(context, listen: false).moreScreenTabInitialIndex;
    return ScreenBaseWithScaffoldAndTabBar(
      key: const Key('MoreScreen-$routeName'),
      title: appBarTitle,
      appBarGradientColors: appBarGradientColors,
      appBarBottomTabs: appBarBottomTabs,
      bodyWidgets: const [SettingsScreen(), HelpScreen(), AboutScreen()],
      tabControllerInitIndex: initIndex,
      onTabIndexChange: (int value) =>
          context.read<AppBarTabsController>().moreScreenTabIndex(value),
    );
  }

  Future<void> _makeExcept() async {
    try {
      throw Exception('test exception');
    } catch (exception, stackTrace) {
      await ErrorsReporter.genericThrow(
        exception.toString(),
        Exception('makeExcept'),
        stackTrace: stackTrace,
      );
    }
  }
}
