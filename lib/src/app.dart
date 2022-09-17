import 'package:davar/src/ui/navigation/navigation.dart';

import 'package:davar/src/ui/onboarding/Onboarding.dart';
import 'package:davar/src/ui/root_widget.dart';
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'authentication/auth_provider.dart';
import 'settings/settings_controller.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return MultiProvider(
      providers: [
        // StreamProvider<User>(create: (_) => AuthenticationRepository().user, initialData: const User(),),
        // ChangeNotifierProxyProvider<User, AuthProvider>(
        //   create: (_) => AuthProvider(),
        //   update: (_, user, authProvider) => authProvider!..handleUserRepositoryStream(user),
        // ),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider()..tryToAuthenticate(),
          lazy: false,
        ),
        ChangeNotifierProvider<NavigationController>(
            create: (_) => NavigationController()),
        ChangeNotifierProvider<AppBarTabsController>(
            create: (_) => AppBarTabsController()),
      ],
      child: AnimatedBuilder(
        animation: settingsController,
        builder: (BuildContext context, Widget? child) {
          bool isEmptyUser =
              context.watch<AuthProvider>().isCurrentUserAnEmptyUser;
          bool isLoading = context.watch<AuthProvider>().isLoading;

          return MaterialApp(
            // Providing a restorationScopeId allows the Navigator built by the
            // MaterialApp to restore the navigation stack when a user leaves and
            // returns to the app after it has been killed while running in the
            // background.
            restorationScopeId: 'app',

            // Provide the generated AppLocalizations to the MaterialApp. This
            // allows descendant Widgets to display the correct translations
            // depending on the user's locale.
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English, no country code
            ],

            // Use AppLocalizations to configure the correct application title
            // depending on the user's locale.
            //
            // The appTitle is defined in .arb files found in the localization
            // directory.
            onGenerateTitle: (BuildContext context) =>
                AppLocalizations.of(context)!.appTitle,

            // Define a light and dark color theme. Then, read the user's
            // preferred ThemeMode (light, dark, or system default) from the
            // SettingsController to display the correct theme.
            theme: ThemeData(),
            darkTheme: ThemeData.dark(),
            themeMode: settingsController.themeMode,

            // Define a function to handle named routes in order to support
            // Flutter web url navigation and deep linking.
            home: isLoading
                ? const FullScreenProgressIndicator()
                : (isEmptyUser
                    ? const Onboarding()
                    : const RootWidget()), // const RootWidget(),
          );
        },
      ),
    );
  }

}
