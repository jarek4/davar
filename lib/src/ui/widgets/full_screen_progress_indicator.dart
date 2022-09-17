import 'package:flutter/material.dart';

class FullScreenProgressIndicator extends StatelessWidget {
  const FullScreenProgressIndicator({Key? key, this.subtitle = 'loading ... wait...'})
      : super(key: key);
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
              height: 80,
              width: 80,
              child: CircularProgressIndicator(
                backgroundColor: Colors.cyanAccent,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              )),
          const SizedBox(height: 6),
          Text(subtitle),
        ],
      )),
    );
  }
}
