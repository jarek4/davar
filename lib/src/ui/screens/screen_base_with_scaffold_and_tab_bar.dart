import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ScreenBaseWithScaffoldAndTabBar extends StatefulWidget {
  const ScreenBaseWithScaffoldAndTabBar(
      {Key? key,
      required this.appBarGradientColors,
      required this.appBarBottomTabs,
      required this.bodyWidgets,
      required this.tabControllerInitIndex,
      required this.onTabIndexChange})
      : super(key: key);

  final List<Color> appBarGradientColors;
  final List<AppBarBottomTabModel> appBarBottomTabs;
  final List<Widget> bodyWidgets;
  final int tabControllerInitIndex;
  final ValueChanged<int> onTabIndexChange;

  @override
  State<ScreenBaseWithScaffoldAndTabBar> createState() => _ScreenBaseWithScaffoldAndTabBarState();
}

class _ScreenBaseWithScaffoldAndTabBarState extends State<ScreenBaseWithScaffoldAndTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _ctr;

  @override
  void initState() {
    super.initState();
    final int tabsNumber = widget.appBarBottomTabs.length;
    _ctr =
        TabController(initialIndex: widget.tabControllerInitIndex, length: tabsNumber, vsync: this);
    _ctr.addListener(_tabControllerOnListen);
  }

  void _tabControllerOnListen() {
    if (_ctr.index != _ctr.previousIndex) {
      _ctr.animateTo(_ctr.index);
      widget.onTabIndexChange(_ctr.index);
    }
  }

  @override
  void dispose() {
    _ctr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('ScreenBaseWithScaffoldAndTabBarState-${widget.tabControllerInitIndex}'),
      appBar: buildAppBar(),
      body: _buildBody(context),
    );
  }

  AppBar buildAppBar() => AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: widget.appBarGradientColors,
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          )),
        ),
        toolbarHeight: 18.0,
        toolbarOpacity: 0.7,
        bottomOpacity: 0.8,
        elevation: 4,
        bottom: _buildAppBarBottom(widget.appBarBottomTabs),
      );

  Widget _buildBody(BuildContext context) => TabBarView(
        controller: _ctr,
        children: widget.bodyWidgets,
      );

  PreferredSizeWidget _buildAppBarBottom(List<AppBarBottomTabModel> bottomBarTabs) {
    return TabBar(
      controller: _ctr,
      onTap: _tabBatOnTap,
      indicatorColor: Colors.white,
      indicatorWeight: 4,
      tabs: bottomBarTabs
          .map((e) => Tab(
              height: 63,
              iconMargin: const EdgeInsets.only(bottom: 2.0),
              icon: Icon(e.icon),
              text: e.title))
          .toList(),
    );
  }

  void _tabBatOnTap(val) {
    _ctr.animateTo(val);
    widget.onTabIndexChange(_ctr.index);
  }
}
