import 'package:davar/src/authentication/auth_provider.dart';
import 'package:davar/src/data/repositories/local/database/db.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Displays detailed information about a SampleItem.
class SampleItemDetailsView extends StatefulWidget {
  const SampleItemDetailsView({super.key});

  static const routeName = '/sample_item';


  @override
  State<SampleItemDetailsView> createState() => _SampleItemDetailsViewState();
}

class _SampleItemDetailsViewState extends State<SampleItemDetailsView> {

 String ver = 'not known';

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }
  _asyncMethod() async {
    final DB db = DB.instance;
    String ver1 = await db.getVersion();
    setState(() {
      ver = ver1;

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('More Information Here'),
            Text('DB version: $ver'),
            TextButton(
              onPressed: () => context.read<AuthProvider>().signOut(),
              child: Text('Log out'),
            ),

          ],
        ),
      ),
    );
  }
}
