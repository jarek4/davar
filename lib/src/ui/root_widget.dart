import 'package:davar/src/authentication/authentication.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/providers/providers.dart';
import 'package:davar/src/ui/navigation/navigation.dart';
import 'package:davar/src/ui/screens/add/add_screen.dart';
import 'package:davar/src/ui/screens/more/more_screen.dart';
import 'package:davar/src/ui/screens/school/school_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RootWidget extends StatelessWidget {
  const RootWidget({Key? key}) : super(key: key);
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final User u = Provider.of<AuthProvider>(context).user;
    final int bottomTabBarSelectedIndex = context.watch<BottomNavigationController>().selectedIndex;
    return MultiProvider(
        providers: [
          ChangeNotifierProxyProvider<AuthProvider, CategoriesProvider>(
            create: (_) => CategoriesProvider(u),
            update: (_, auth, __) => CategoriesProvider(auth.user),
            lazy: false,
          ),
          ChangeNotifierProvider<SearchWordsProvider>(
            create: (context) =>
                SearchWordsProvider(Provider.of<WordsProvider>(context, listen: false)),
            lazy: true,
          ),
          ChangeNotifierProvider<StatisticsProvider>(
            create: (context) => StatisticsProvider(context.read<WordsProvider>()),
            lazy: true,
          ),
        ],
        child: Scaffold(
          body: [
            const SchoolScreen(),
            const AddScreen(),
            const MoreScreen(),
          ].elementAt(bottomTabBarSelectedIndex),
          bottomNavigationBar: const BottomNavigation(),
        ));
  }
}
/*
  @override
  Widget build(BuildContext context) {
    final User u = Provider.of<AuthProvider>(context).user;
    final int bottomTabBarSelectedIndex = context.watch<BottomNavigationController>().selectedIndex;
    return MultiProvider(
        providers: [
          ChangeNotifierProxyProvider<AuthProvider, WordsProvider>(
            create: (_) => WordsProvider(u),
            update: (_, auth, __) => WordsProvider(auth.user),
            lazy: false,
          ),
          ChangeNotifierProxyProvider<AuthProvider, CategoriesProvider>(
            create: (_) => CategoriesProvider(u),
            update: (_, auth, __) => CategoriesProvider(auth.user),
            lazy: false,
          ),
          ChangeNotifierProvider<SearchWordsProvider>(
            create: (context) =>
                SearchWordsProvider(Provider.of<WordsProvider>(context, listen: false)),
            lazy: true,
          ),
          ChangeNotifierProvider<StatisticsProvider>(
            create: (context) => StatisticsProvider(context.read<WordsProvider>()),
            lazy: true,
          ),
        ],
        child: Scaffold(
          body: [
             const SchoolScreen(),
            /*ChangeNotifierProvider<StatisticsProvider>(
              // when StatisticsProvider is inside MultiProvider it makes problems.
              // WordsProvider is disposing when bottom tab is changed!
              create: (context) => StatisticsProvider(context.read<WordsProvider>()),
              lazy: true,
              child: const SchoolScreen(),
            ),*/
            const AddScreen(),
            const MoreScreen(),
          ].elementAt(bottomTabBarSelectedIndex),
          bottomNavigationBar: const BottomNavigation(),
        ));
  }
 */
