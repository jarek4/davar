import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'backup.dart';

class BackupView extends StatelessWidget {
  const BackupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String title = AppLocalizations.of(context)?.settingsBackup ?? 'Backup';
    final String attention = AppLocalizations.of(context)?.settingsBackupAttention ??
        'Attention! all current words and sentences will be replaced.';
    final String import = AppLocalizations.of(context)?.settingsImport ?? 'Import backup copy';
    final String exportTo = AppLocalizations.of(context)?.settingsExportTo ??
        'You can export all your data to the file:';
    final String export = AppLocalizations.of(context)?.settingsExport ?? 'Export backup copy';

    return Scaffold(
      appBar: AppBar(title: Text(title), centerTitle: true),
      body: ChangeNotifierProvider<BackupProvider>(
          create: (context) => BackupProvider(),
          lazy: true,
          builder: (context, child) {
            return Column(children: [
              const SizedBox(height: 18.0),
              const Divider(thickness: 1.8, indent: 38.0, endIndent: 38.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 38.0),
                child: Text(attention, textAlign: TextAlign.start),
              ),
              const SizedBox(height: 28.0),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Text(import),
                Selector<BackupProvider, BackupStatus>(
                    selector: (_, state) => state.status,
                    builder: (BuildContext context, status, child) {
                      final bool isLoading = status == BackupStatus.loading;
                      return IconButton(
                          onPressed: () => isLoading ? null : _importHandle(context), icon: child!);
                    },
                    child: const Icon(Icons.cloud_download))
              ]),
              const Divider(thickness: 1.8, indent: 38.0, endIndent: 38.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 38.0),
                child: Text('$exportTo: davar_backup.db', textAlign: TextAlign.center),
              ),
              const SizedBox(height: 28.0),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Text(export),
                Selector<BackupProvider, BackupStatus>(
                    selector: (_, state) => state.status,
                    builder: (BuildContext context, status, child) {
                      final bool isLoading = status == BackupStatus.loading;
                      return IconButton(
                        onPressed: () => isLoading
                            ? null
                            : context.read<BackupProvider>().makeDatabaseFileCopy(),
                        icon: child!,
                      );
                    },
                    child: const Icon(Icons.cloud_upload_outlined))
              ]),
              const SizedBox(height: 10.0),
              const Divider(thickness: 1.8, indent: 38.0, endIndent: 38.0),
              // when loading or saved file location:
              Selector<BackupProvider, BackupStatus>(
                  selector: (_, state) => state.status,
                  builder: (BuildContext context, status, _) {
                    if (status == BackupStatus.loading) {
                      return const Center(
                          child:
                              SizedBox(height: 30.0, child: CircularProgressIndicator.adaptive()));
                    }
                    return Text(context.read<BackupProvider>().info,
                        style: const TextStyle(fontSize: 16.0), textAlign: TextAlign.center);
                  }),
              const SizedBox(height: 8.0),
              Selector<BackupProvider, BackupStatus>(
                  selector: (_, state) => state.status,
                  builder: (BuildContext context, status, _) {
                    if (status == BackupStatus.error) {
                      return Text(context.read<BackupProvider>().error,
                          style: const TextStyle(fontSize: 16.0), textAlign: TextAlign.center);
                    }
                    return const SizedBox.shrink();
                  }),
            ]);
          }),
    );
  }

  void _importHandle(BuildContext context) {
    final String confirm = AppLocalizations.of(context)?.backupConfirm ?? 'Are you sure you want to replace all your data?';
    _showDialog(
      context,
      confirm,
      () {
        context.read<BackupProvider>().restoreDatabaseFromFile();
        Navigator.of(context).pop();
      },
    );
  }

  void _showDialog(BuildContext context, String title, VoidCallback onConfirmation) {
    final String cancel = AppLocalizations.of(context)?.cancel ?? 'Cancel';
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(title, textAlign: TextAlign.center),
              content: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(cancel)),
                TextButton(onPressed: onConfirmation, child: const Text('OK'))
              ]),
            ));
  }
}
