import 'package:flutter/material.dart';

class LoggedOutView extends StatelessWidget {
  const LoggedOutView({Key? key, required this.loginOnPressed}) : super(key: key);
  static const routeName = '/logged_out';

  final VoidCallback loginOnPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Thank you!'),
            const SizedBox(height: 5.0),
            const Text('Hope to see you soon'),
            const SizedBox(height: 10.0),
            TextButton(
              onPressed: loginOnPressed,
              child: const Text('Log in'),
            )
          ],
        ),
      ),
    );
  }
}
