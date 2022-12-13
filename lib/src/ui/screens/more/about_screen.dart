import 'package:davar/src/authentication/authentication.dart';
import 'package:davar/src/davar_ads/davar_ads.dart';
import 'package:davar/src/ui/screens/more/about/privacy_terms_provider.dart';
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'about/privacy_terms_view.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (BuildContext context, AuthProvider provider, _) {
      switch (provider.status) {
        case AuthenticationStatus.authenticated:
          return _buildScreenBody(context);
        default:
          return const UnauthenticatedInfo(key: Key('More-AboutScreen'));
      }
    });
  }

  Column _buildScreenBody(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      const Padding(
        padding: EdgeInsets.only(bottom: 4.0, top: 4.0),
        child: DavarAdBanner(key: Key('More-AboutScreen-top-banner-320')),
      ),
      Expanded(
        child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            key: const Key('More-AboutScreen'),
            shrinkWrap: true,
            children: [
              const SizedBox(height: 12.0),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Version'),
                    Text(utils.AppConst.appVersionAsString),
                  ],
                ),
              ),
              const Divider(thickness: 1.2),
              _terms(context),
              const Divider(thickness: 1.2),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Privacy statement'),
                    Icon(Icons.arrow_forward_ios_rounded),
                  ],
                ),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => ChangeNotifierProvider<PrivacyTermsProvider>(
                        create: (context) => PrivacyTermsProvider(),
                        builder: (context, _) {
                          return PrivacyTermsView('init data',
                              context.read<PrivacyTermsProvider>().readPrivacyPolicy());
                        }),
                  ),
                ),
              ),
              const Divider(thickness: 1.2),
              _devContact(context),
              const Divider(thickness: 1.2),
            ]),
      ),
    ]);
  }

  ListTile _terms(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text('Terms of service'),
          Icon(Icons.arrow_forward_ios_rounded),
        ],
      ),
      onTap: () => showAboutDialog(
        context: context,
        applicationVersion: utils.AppConst.appVersionAsString,
        applicationIcon: Image.asset(utils.AssetsPath.davarLogo, width: 40, height: 40),
        applicationLegalese: 'BSD 2 License',
      ),
    );
  }

  ListTile _devContact(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text('Contact with developer'),
          Icon(Icons.arrow_forward_ios_rounded),
        ],
      ),
      onTap: () => _showDialog(context, 'Contact me', utils.AppConst.developerEmail),
    );
  }

  void _showDialog(BuildContext context, String title, String info) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(title, textAlign: TextAlign.center),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(info),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
                    ],
                  ),
                ],
              ),
            ));
  }
}
