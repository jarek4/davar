import 'package:davar/src/ui/navigation/navigation.dart';
import 'package:davar/src/ui/screens/add/add_screen.dart';
import 'package:davar/src/ui/screens/more/more_screen.dart';
import 'package:davar/src/ui/screens/school/school_screen.dart';
import 'package:davar/src/ui/screens/you/you_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RootWidget extends StatelessWidget {
  const RootWidget({Key? key}) : super(key: key);
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        const SchoolScreen(),
        const AddScreen(),
        const YouScreen(),
        const MoreScreen(),
      ].elementAt((context.watch<BottomNavigationController>().selectedIndex)),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
