import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'backup.dart';

class BackupView extends StatelessWidget {
  const BackupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backup'),
        centerTitle: true,
      ),
      body: ChangeNotifierProvider<BackupProvider>(
          create: (context) => BackupProvider(),
          lazy: true,
          builder: (context, child) {
            return Column(
              children: [
                const SizedBox(height: 18.0),
                const Divider(thickness: 1.8, indent: 38.0, endIndent: 38.0),
                const Text(
                  'Attention!\nIf you import any data from a file, all current words and sentences will be replaced.',
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 28.0),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  const Text('Import backup copy'),
                  Consumer<BackupProvider>(builder: (BuildContext context, BackupProvider bp, _) {
                    final bool isLoading = bp.status == BackupStatus.loading;
                    return IconButton(
                        onPressed: () => isLoading ? null : _importHandle(context),
                        icon: const Icon(Icons.cloud_download));
                  })
                ]),
                const Divider(thickness: 1.8, indent: 38.0, endIndent: 38.0),
                const Text('You can export all your data to the file: davar_backup.db', textAlign: TextAlign.end,),
                const SizedBox(height: 28.0),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  const Text('Export backup copy'),
                  Consumer<BackupProvider>(builder: (BuildContext context, BackupProvider p, _) {
                    final bool isLoading = p.status == BackupStatus.loading;
                    return IconButton(
                        onPressed: () => isLoading ? null : p.makeDatabaseFileCopy(),
                        icon: const Icon(Icons.cloud_upload_outlined));
                  })
                ]),
                const SizedBox(height: 10.0),
                const Divider(thickness: 1.8, indent: 38.0, endIndent: 38.0),
                Consumer<BackupProvider>(builder: (BuildContext context, BackupProvider state, _) {
                  if (state.status == BackupStatus.loading) {
                    return const Center(
                        child: SizedBox(height: 30.0, child: CircularProgressIndicator.adaptive()));
                  } else {
                    return Text(state.info,
                        style: const TextStyle(fontSize: 16.0), textAlign: TextAlign.center);
                  }
                }),
                const SizedBox(height: 8.0),
                Consumer<BackupProvider>(builder: (BuildContext context, BackupProvider state, _) {
                  if (state.status == BackupStatus.error) {
                    return Text(state.error,
                        style: const TextStyle(fontSize: 16.0), textAlign: TextAlign.center);
                  }
                  return const SizedBox.shrink();
                }),
              ],
            );
          }),
    );
  }

  void _importHandle(BuildContext context) {
    _showDialog(
      context,
      'Are you sure you want to overwrite all your data?',
      () {
        context.read<BackupProvider>().restoreDatabaseFromFile();
        Navigator.of(context).pop();
      },
    );
  }

  void _showDialog(BuildContext context, String title, VoidCallback onConfirmation) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(title, textAlign: TextAlign.center),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                  TextButton(onPressed: onConfirmation, child: const Text('OK'))
                ],
              ),
            ));
  }
}
