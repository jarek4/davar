import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'backup.dart';

class BackupView extends StatelessWidget {
  const BackupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ChangeNotifierProvider<BackupProvider>(
          create: (context) => BackupProvider(),
          lazy: true,
          builder: (context, child) {
            return Column(
              children: [
                const SizedBox(height: 18.0),
                Consumer<BackupProvider>(builder: (BuildContext context, BackupProvider state, _) {
                  return Text(state.info,
                      style: const TextStyle(fontSize: 18.0), textAlign: TextAlign.center);
                }),
                const SizedBox(height: 18.0),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  const Text('Import backup copy'),
                  Consumer<BackupProvider>(builder: (BuildContext context, BackupProvider bp, _) {
                    return IconButton(
                        onPressed: () => _importHandle(context),
                        icon: const Icon(Icons.cloud_download));
                  })
                ]),
                const SizedBox(height: 18.0),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  const Text('Export backup copy'),
                  Consumer<BackupProvider>(builder: (BuildContext context, BackupProvider p, _) {
                    return IconButton(
                        onPressed: () => p.makeDatabaseFileCopy(),
                        icon: const Icon(Icons.cloud_upload_outlined));
                  })
                ]),
                const SizedBox(height: 18.0),
                Consumer<BackupProvider>(builder: (BuildContext context, BackupProvider state, _) {
                  return Text('Error: ${state.error}');
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
      () => context.read<BackupProvider>().restoreDatabaseFromFile(),
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
