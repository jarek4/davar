import 'package:davar/src/theme/theme.dart';
import 'package:davar/src/theme/theme.dart' as theme;
import 'package:davar/src/ui/navigation/navigation.dart';
import 'package:davar/src/ui/onboarding/Onboarding.dart';
import 'package:davar/src/ui/root_widget.dart';
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:davar/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'authentication/authentication.dart';
import 'settings/settings_controller.dart';

/// The Widget that configures your application.
class DavarApp extends StatelessWidget {
  const DavarApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // StreamProvider<User>(create: (_) => AuthenticationRepository().user, initialData: const User(),),
        // ChangeNotifierProxyProvider<User, AuthProvider>(
        //   create: (_) => AuthProvider(),
        //   update: (_, user, authProvider) => authProvider!..handleUserRepositoryStream(user),
        // ),
        ChangeNotifierProvider<SettingsController>.value(
          value: settingsController,
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider()..tryToAuthenticate(),
          lazy: false,
        ),
        ChangeNotifierProvider<BottomNavigationController>(
            create: (_) => BottomNavigationController()),
        ChangeNotifierProvider<AppBarTabsController>(create: (_) => AppBarTabsController()),
      ],
      child: AnimatedBuilder(
        animation: settingsController,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            // Providing a restorationScopeId allows the Navigator built by the
            // MaterialApp to restore the navigation stack when a user leaves and
            // returns to the app after it has been killed while running in the
            // background.
            scaffoldMessengerKey: scaffoldKey,
            restorationScopeId: 'app',
            navigatorObservers: [SentryNavigatorObserver()],

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
            onGenerateTitle: (BuildContext context) => AppLocalizations.of(context)!.appTitle,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: DavarColors.materialPrimarySwatch,
              ),
              scaffoldBackgroundColor: DavarColors.mainBackground,
            ),
            darkTheme: ThemeData.dark(),
            themeMode: settingsController.themeMode,
            // themeMode: ThemeMode.dark,
            home: Consumer<AuthProvider>(builder: (BuildContext context, AuthProvider provider, _) {
              print('app.dart - provider.status: ${provider.status}');
              switch (provider.status) {
                case AuthenticationStatus.authenticated:
                  return const RootWidget();
                case AuthenticationStatus.error:
                  return _onAuthenticationError(provider.authenticationError, context);
                case AuthenticationStatus.unauthenticated:
                  return const Onboarding();
                case AuthenticationStatus.login:
                  return ChangeNotifierProvider<LoginProvider>(
                      create: (_) => LoginProvider(), child: const LoginView());
                case AuthenticationStatus.register:
                  return ChangeNotifierProvider<RegistrationProvider>(
                      create: (_) => RegistrationProvider(), child: const RegisterView());
                case AuthenticationStatus.loggedOut:
                  return LoggedOutView(
                      loginOnPressed: () => context.read<AuthProvider>().onLoginRequest());
                default:
                  return _authenticationStatusUnknown(context, 'Trying to log you in... ');
              }
            }),
          );
        },
      ),
    );
  }

  Scaffold _authenticationStatusUnknown(BuildContext context, String text) => Scaffold(
        body: Container(
          color: theme.DavarColors.mainBackground,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text, textAlign: TextAlign.center),
              const SizedBox(height: 30),
              const CircularProgressIndicator(),
              const SizedBox(height: 30),
              TextButton(
                onPressed: () => context.read<AuthProvider>().onCancelAuthenticationRequest(),
                child: const Icon(Icons.arrow_circle_left_outlined),
              ),
            ],
          )),
        ),
      );

  FullScreenProgressIndicator _onAuthenticationError(String error, BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _showMsg(context, error);
    });
    return FullScreenProgressIndicator(
      additionalErrorMessage: error,
      actionButton: TextButton(
        onPressed: () => context.read<AuthProvider>().onCancelAuthenticationRequest(),
        child: const Icon(Icons.arrow_circle_left_outlined),
      ),
    );
  }

  void _showMsg(BuildContext context, String authenticationError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.grey,
        content: Text(authenticationError, textAlign: TextAlign.center),
      ),
    );
  }
}
