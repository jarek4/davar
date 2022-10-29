import 'package:davar/src/authentication/authentication.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/providers/providers.dart';
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
    User u = Provider.of<AuthProvider>(context).user;
    final int bottomTabBarSelectedIndex = context.watch<BottomNavigationController>().selectedIndex;
    return MultiProvider(
        providers: [
          ChangeNotifierProxyProvider<AuthProvider, WordsProvider>(
            create: (_) => WordsProvider(u),
            update: (_, auth, __) => WordsProvider(auth.user),
          ),
          ChangeNotifierProxyProvider<AuthProvider, CategoriesProvider>(
            create: (_) => CategoriesProvider(u),
            update: (_, auth, __) => CategoriesProvider(auth.user),
          ),
          ChangeNotifierProvider<FilteredWordsProvider>(
            create: (context) => FilteredWordsProvider(u),
          ),
        ],
        child: Scaffold(
          body: [
            const SchoolScreen(),
            const AddScreen(),
            const YouScreen(),
            const MoreScreen(),
          ].elementAt(bottomTabBarSelectedIndex),
          bottomNavigationBar: const BottomNavigation(),
        ));
  }
}
