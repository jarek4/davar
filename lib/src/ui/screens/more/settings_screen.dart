import 'package:davar/src/authentication/authentication.dart';
import 'package:davar/src/backup/backup.dart';
import 'package:davar/src/data/models/supported_languages/supported.dart';
import 'package:davar/src/davar_ads/davar_ads.dart';
import 'package:davar/src/settings/settings_controller.dart';
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (BuildContext context, AuthProvider provider, _) {
      switch (provider.status) {
        case AuthenticationStatus.authenticated:
          return _buildScreenBody(context, provider.user.name, provider.user.email,
              provider.user.native, provider.user.learning);
        default:
          return const UnauthenticatedInfo(key: Key('More-SettingsScreen-not authenticated'));
      }
    });
  }

  Widget _buildScreenBody(
      BuildContext context, String name, String email, String native, String learning) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 4.0, bottom: 8.0),
          child: DavarAdBanner(key: Key('More-SettingsScreen-top-banner-320')),
        ),
        Expanded(
          child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              key: const Key('More-SettingsScreen'),
              shrinkWrap: true,
              children: [_buildThemeModeTile(), _buildLanguageTile(), _buildBackupTile(context)]),
        ),
      ],
    );
  }

  Widget _buildThemeModeTile() {
    return Consumer<SettingsController>(
        builder: (BuildContext context, SettingsController settings, _) {
      final ThemeMode mode = settings.themeMode;
      const ThemeMode a = ThemeMode.system;
      const ThemeMode d = ThemeMode.dark;
      const ThemeMode l = ThemeMode.light;
      final Color inactiveColor =
          Theme.of(context).iconTheme.color?.withOpacity(0.6) ?? Colors.black.withOpacity(0.6);
      Color activeColor = Theme.of(context).colorScheme.primary.withOpacity(0.8);
      return ExpansionTile(
        leading: const Icon(Icons.sunny_snowing),
        title: const Text('Light/Dark mode'),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 6.0, left: 18.0, right: 8.0),
            child: Row(children: [
              const Expanded(child: Text('Auto')),
              Expanded(
                  child: IconButton(
                      onPressed: () => settings.updateThemeMode(a),
                      icon: Icon(Icons.device_unknown_rounded,
                          color: mode == a ? activeColor : inactiveColor))),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 6.0, left: 18.0, right: 8.0),
            child: Row(children: [
              const Expanded(child: Text('Light mode')),
              Expanded(
                  child: IconButton(
                      onPressed: () => settings.updateThemeMode(l),
                      icon:
                          Icon(Icons.light_mode, color: mode == l ? activeColor : inactiveColor))),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 6.0, left: 18.0, right: 8.0),
            child: Row(children: [
              const Expanded(child: Text('Dark mode')),
              Expanded(
                  child: IconButton(
                      onPressed: () => settings.updateThemeMode(d),
                      icon: Icon(Icons.dark_mode_outlined,
                          color: mode == d ? activeColor : inactiveColor))),
            ]),
          )
        ],
      );
    });
  }

  Widget _buildLanguageTile() {
    return ExpansionTile(
      leading: const Icon(Icons.translate),
      title: const Text('Language'),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 18.0, left: 18.0, right: 18.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Flexible(child: Text('Application language:')),
            Flexible(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<DavarLanguage>(
                  elevation: 16,
                  hint: const Text('App language'),
                  value: SupportedLanguages.list[2],
                  onChanged: (d) {},
                  items: SupportedLanguages.list
                      .map<DropdownMenuItem<DavarLanguage>>((DavarLanguage value) {
                    return DropdownMenuItem<DavarLanguage>(
                        key: Key('DropdownMenuItem-$value'), value: value, child: Text(value.name));
                  }).toList(),
                ),
              ),
            )
          ]),
        )
      ],
    );
  }

  Widget _buildBackupTile(BuildContext context) {
    return ExpansionTile(
      leading: const Icon(Icons.restore),
      title: const Text('Backup'),
      children: <Widget>[
        const Text('You can export all your data to the file: davar_backup.db'),
        const SizedBox(height: 8.0),
        const Text(
            'Attention!\nIf you import any data from a file, all current words and sentences will be replaced.'),
        const Divider(thickness: 1.2, height: 12.0),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 18.0),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                const Text('Import/Export backup copy'),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BackupView(), fullscreenDialog: true));
                    },
                    icon: const Icon(Icons.restore))
              ]),
            ],
          ),
        ),
      ],
    );
  }
}
