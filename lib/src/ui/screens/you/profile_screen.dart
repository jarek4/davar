import 'package:davar/src/authentication/authentication.dart';
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (BuildContext context, AuthProvider provider, _) {
      switch (provider.status) {
        case AuthenticationStatus.authenticated:
          return _buildScreenBody(context, provider.user.name, provider.user.email,
              provider.user.native, provider.user.learning);
        default:
          return const UnauthenticatedInfo(key: Key('You-ProfileScreen-not authenticated'));
      }
    });
  }

  Column _buildScreenBody(
      BuildContext context, String name, String email, String native, String learning) {
    Orientation orientation = MediaQuery.of(context).orientation;
    final bool isLandscape = orientation == Orientation.landscape;
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Expanded(
        child: ListView(
            padding: EdgeInsets.symmetric(horizontal: isLandscape ? 80 : 30),
            key: const Key('ProfileScreen-signed in'),
            shrinkWrap: true,
            children: [
              const Divider(thickness: 1.2),
              ListTile(
                title: Text('Name: $name'),
                leading: const Icon(Icons.person_outline),
              ),
              const Divider(thickness: 1.2),
              ListTile(
                title: Text('Email: $email'),
                leading: const Icon(Icons.email_outlined),
              ),
              const Divider(thickness: 1.2),
              ListTile(
                title: Text('Your language: $native'),
                leading: const Icon(Icons.language_outlined),
              ),
              const Divider(thickness: 1.2),
              ListTile(
                title: Text('You learn: $learning'),
                leading: const Icon(Icons.school_outlined),
              ),
              const Divider(thickness: 1.2),
              ListTile(
                title: const Text('Logout'),
                leading: const Icon(Icons.logout_outlined),
                onTap: () => _showDialog(context, 'Are you sure, you want to logout?', () => context.read<AuthProvider>().signOut()),
              ),
              const Divider(thickness: 1.2),
              ListTile(
                title: Text('Remove user $name data'),
                leading: const Icon(Icons.delete_sweep_outlined),
                onTap: () => _showDialog(context, 'Are you sure, you want to remove current user?',
                    () => context.read<AuthProvider>().signOut()),
              ),
              const Divider(thickness: 1.2),
            ]),
      ),
    ]);
  }

  void _showDialog(BuildContext context, String title, VoidCallback onConfirmation) {

    void okBtnHandle() {
      onConfirmation();
      Navigator.of(context).pop();
    }
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(title, textAlign: TextAlign.center),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                  TextButton(onPressed: okBtnHandle, child: const Text('OK'))
                ],
              ),
            ));
  }
}
