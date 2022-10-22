import 'package:davar/src/authentication/authentication.dart';
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (BuildContext context, AuthProvider provider, _) {
      switch (provider.status) {
        case AuthenticationStatus.authenticated:
        // return _buildScreenBody(
        //     context, provider.user.name, provider.user.email, provider.user.native,
        //     provider.user.learning);
          return const UnauthenticatedInfo(key: Key('value4'),);
        default:
          return const UnauthenticatedInfo(key: Key('School-StatisticsScreen'));
      }
    });
  }
}