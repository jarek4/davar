import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoggedOutView extends StatelessWidget {
  const LoggedOutView({Key? key, required this.loginOnPressed}) : super(key: key);
  static const routeName = '/logged_out';

  final VoidCallback loginOnPressed;

  @override
  Widget build(BuildContext context) {
    final String thx = AppLocalizations.of(context)?.thankYou ?? 'Thank you!';
    final String seeYou = '${AppLocalizations.of(context)?.seeYou ?? 'Hope to see you soon'}!';
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(thx),
          const SizedBox(height: 5.0),
          Text(seeYou),
          const SizedBox(height: 10.0),
          TextButton(
            onPressed: loginOnPressed,
            child: const Text('Log in'),
          )
        ]),
      ),
    );
  }
}
