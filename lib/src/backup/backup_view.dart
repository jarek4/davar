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
            return Consumer<BackupProvider>(builder: (BuildContext context, BackupProvider provider, _) {
            return Column(
              children: [
                Text(provider.status.toString()),
                const SizedBox(height: 18.0),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  const Text('Import backup copy'),
                  IconButton(
                      onPressed: () => provider.restoreDatabaseFromFile(),
                      icon: const Icon(Icons.cloud_download))
                ]),
                const SizedBox(height: 18.0),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  const Text('Export backup copy'),
                  IconButton(
                      onPressed: () => provider.makeDatabaseFileCopy(),
                      icon: const Icon(Icons.cloud_upload_outlined))
                ]),
                const SizedBox(height: 18.0),
                Text('Error: ${provider.error}'),
              ],
            );
          });
        }
      ),
    );
  }
}
