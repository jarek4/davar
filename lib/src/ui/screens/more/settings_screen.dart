import 'package:davar/src/backup/backup.dart';
import 'package:davar/src/data/models/supported_languages/supported.dart';
import 'package:davar/src/davar_ads/davar_ads.dart';
import 'package:davar/src/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Padding(
        padding: EdgeInsets.only(top: 4.0, bottom: 8.0),
        child: DavarAdBanner(key: Key('More-SettingsScreen-top-banner-320')),
      ),
      Expanded(
        child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            key: const Key('More-SettingsScreen'),
            shrinkWrap: true,
            children: [
              _buildThemeModeTile(),
              _buildLanguageTile(context),
              _buildBackupTile(context)
            ]),
      ),
    ]);
  }

  Widget _buildThemeModeTile() {
    return Consumer<SettingsController>(
        builder: (BuildContext context, SettingsController settings, _) {
      final ThemeMode tm = settings.themeMode;
      const ThemeMode tmS = ThemeMode.system;
      const ThemeMode tmD = ThemeMode.dark;
      const ThemeMode tmL = ThemeMode.light;
      final Color inactiveColor =
          Theme.of(context).iconTheme.color?.withOpacity(0.6) ?? Colors.black.withOpacity(0.6);
      Color activeColor = Theme.of(context).colorScheme.primary.withOpacity(0.8);
      final String mode = AppLocalizations.of(context)?.settingsMode ?? 'Light/Dark mode';
      final String light = AppLocalizations.of(context)?.settingsLight ?? 'Light';
      final String dark = AppLocalizations.of(context)?.settingsDark ?? 'Dark';
      return ExpansionTile(
          leading: const Icon(Icons.sunny_snowing),
          title: Text(mode),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0, left: 18.0, right: 8.0),
              child: Row(children: [
                const Expanded(child: Text('Auto')),
                Expanded(
                    child: IconButton(
                        onPressed: () => settings.updateThemeMode(tmS),
                        icon: Icon(Icons.device_unknown_rounded,
                            color: tm == tmS ? activeColor : inactiveColor))),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0, left: 18.0, right: 8.0),
              child: Row(children: [
                Expanded(child: Text(light)),
                Expanded(
                    child: IconButton(
                        onPressed: () => settings.updateThemeMode(tmL),
                        icon: Icon(Icons.light_mode,
                            color: tm == tmL ? activeColor : inactiveColor))),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0, left: 18.0, right: 8.0),
              child: Row(children: [
                Expanded(child: Text(dark)),
                Expanded(
                    child: IconButton(
                        onPressed: () => settings.updateThemeMode(tmD),
                        icon: Icon(Icons.dark_mode_outlined,
                            color: tm == tmD ? activeColor : inactiveColor))),
              ]),
            )
          ]);
    });
  }

  Widget _buildLanguageTile(BuildContext context) {
    final String lang = AppLocalizations.of(context)?.settingsLanguage ?? 'Language';
    return ExpansionTile(
      leading: const Icon(Icons.translate),
      title: Text(lang),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 18.0, left: 18.0, right: 18.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Flexible(child: Text('App ${lang.toLowerCase()}:')),
            _buildDropdownLanguagePicker()
          ]),
        )
      ],
    );
  }

  Widget _buildDropdownLanguagePicker() {
    return Flexible(
      child: Consumer<SettingsController>(
          builder: (BuildContext context, SettingsController settings, _) {
        String current = 'system';
        final String lang = AppLocalizations.of(context)?.settingsLanguage ?? 'Language';
        if (settings.localeCode != null) {
          current = SupportedLanguages.codeToLanguage(settings.localeCode!);
        }
        return DropdownButtonHideUnderline(
          child: DropdownButton<String>(
              isExpanded: true,
              elevation: 16,
              hint: Text('App ${lang.toLowerCase()}'),
              value: current,
              onChanged: (v) =>
                  settings.updateLocale(SupportedLanguages.languageToCode(v ?? 'system')),
              items: SupportedLanguages.localizeNames.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                    key: Key('DropdownMenuItem-$value'), value: value, child: Text(value));
              }).toList()),
        );
      }),
    );
  }

  Widget _buildBackupTile(BuildContext context) {
    final String backup = AppLocalizations.of(context)?.settingsBackup ?? 'Backup';
    final String importExport =
        AppLocalizations.of(context)?.importExport ?? 'Import/Export backup copy';
    return ExpansionTile(
        leading: const Icon(Icons.restore),
        title: Text(backup),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 18.0),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Expanded(
                    child: Text(importExport,
                        softWrap: false, maxLines: 2, overflow: TextOverflow.ellipsis)),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BackupView(), fullscreenDialog: true));
                    },
                    icon: const Icon(Icons.restore))
              ]),
            ]),
          ),
        ]);
  }
}
