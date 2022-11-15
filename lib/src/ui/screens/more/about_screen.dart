import 'package:davar/src/authentication/authentication.dart';
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            key: const Key('More-AboutScreen'),
            shrinkWrap: true,
            children: const [
              ListTile(
                title: Text('version'),
                leading: Icon(Icons.cloud_upload_outlined),
              ),
              Divider(thickness: 1.2),
              ListTile(
                title: Text('licences'),
                leading: Icon(Icons.cloud_upload_outlined),
              ),
              Divider(thickness: 1.2),
              ListTile(
                title: Text('dev'),
                leading: Icon(Icons.cloud_download),
              ),
              Divider(thickness: 1.2),

            ]),
      ),
    ]);
  }
}