import 'package:davar/src/authentication/authentication.dart';
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BackupScreen extends StatelessWidget {
  const BackupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (BuildContext context, AuthProvider provider, _) {
      switch (provider.status) {
        case AuthenticationStatus.authenticated:
          return _buildScreenBody(
              context, provider.user.name, provider.user.email, provider.user.native,
              provider.user.learning);
        default:
          return const UnauthenticatedInfo(key: Key('You-BackupScreen-not authenticated'));
      }
    });
  }
  Column _buildScreenBody(BuildContext context,String name, String email, String native, String learning) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: SizedBox(
          // height: 80,
            child: Column(
              children: const [
                Text('You can export all your data to the file: davar_backup.db', textAlign: TextAlign.center,),
                SizedBox(height: 8.0),
                Text('Attention!\nIf you import any data from a file, all current words and sentences will be replaced.', textAlign: TextAlign.center,),
                Divider(thickness: 1.2),
              ],
            ),
          ),
        ),
      Expanded(
        child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            key: const Key('You-BackupScreen'),
            shrinkWrap: true,
            children: const [
              ListTile(
                title: Text('Import backup copy'),
                leading: Icon(Icons.cloud_download),
              ),
              Divider(thickness: 1.2),
              ListTile(
                title: Text('Export backup copy'),
                leading: Icon(Icons.cloud_upload_outlined),
              ),
              Divider(thickness: 1.2),
            ]),
      ),
    ]);
  }

  void _showDialog(BuildContext context, String title, VoidCallback onConfirmation) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(title, textAlign: TextAlign.center),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
              TextButton(onPressed: onConfirmation, child: const Text('OK'))
            ],
          ),
        )
    );
  }
}