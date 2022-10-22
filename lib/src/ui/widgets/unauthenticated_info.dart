import 'package:flutter/material.dart';

class UnauthenticatedInfo extends StatelessWidget {
  const UnauthenticatedInfo(
      {Key? key,
      this.info = 'You are not signed in',
      this.icon = const Icon(Icons.person_off_outlined)})
      : super(key: key);

  final String info;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Expanded(
        child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            key: const Key('ProfileScreen-not signed in'),
            shrinkWrap: true,
            children: [
              const Divider(thickness: 1.2),
              ListTile(
                title: Text(info),
                leading: icon,
              ),
              const Divider(thickness: 1.2),
            ]),
      ),
    ]);
  }
}
