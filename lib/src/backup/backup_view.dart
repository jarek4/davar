import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'backup.dart';

class BackupView extends StatelessWidget {
  const BackupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<BackupProvider>(builder: (BuildContext context, BackupProvider provider, _) {
        return Column(
          children: [
            const SizedBox(height: 18.0),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              const Text('Import backup copy'),
              IconButton(onPressed: () {}, icon: const Icon(Icons.cloud_download))
            ]),
            const SizedBox(height: 18.0),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              const Text('Export backup copy'),
              IconButton(onPressed: () {}, icon: const Icon(Icons.cloud_upload_outlined))
            ]),
            const SizedBox(height: 18.0),
          ],
        );
      }),
    );
  }
}
