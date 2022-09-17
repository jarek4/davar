import 'package:davar/src/ui/navigation/navigation.dart';
import 'package:davar/src/ui/screens/add_screen.dart';
import 'package:davar/src/ui/screens/more_screen.dart';
import 'package:davar/src/ui/screens/school_screen.dart';
import 'package:davar/src/ui/screens/you_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RootWidget extends StatelessWidget {
  const RootWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        const SchoolScreen(),
        const AddScreen(),
        const YouScreen(),
        const MoreScreen(),
      ].elementAt((context.watch<NavigationController>().selectedIndex)),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
