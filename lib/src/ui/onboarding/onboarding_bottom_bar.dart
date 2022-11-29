import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'privacy_terms_view.dart';

class OnboardingBottomBar extends StatelessWidget {
  const OnboardingBottomBar({
    Key? key,
    required this.leftBtnText,
    required this.rightBtnText,
    required this.leftBtnOnPressed,
    required this.rightBtnOnPressed,
  }) : super(key: key);

  final String leftBtnText;
  final String rightBtnText;
  final VoidCallback leftBtnOnPressed;
  final VoidCallback rightBtnOnPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text('Signing in, I agree to the', style: TextStyle(fontSize: 12)),
              _buildTermsLink(context),
              const Text(
                'and',
                style: TextStyle(fontSize: 12),
              ),
              _buildPrivacyLink(context),
            ],
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
            child: Container(
              color: Colors.green.shade400,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  TextButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.green.shade400)),
                      onPressed: leftBtnOnPressed,
                      child: Text(leftBtnText,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                              height: 2))),
                  TextButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.green.shade400)),
                      onPressed: rightBtnOnPressed,
                      child: Text(rightBtnText,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                              height: 2)))
                ]),
              ),
            ),
          ),
        ]);
  }

  TextButton _buildPrivacyLink(BuildContext context) {
    return TextButton(
      onPressed: () => _pushFullScreenDialog(context, utils.AssetsPath.txtPrivacyStatement),
      child: const Text('privacy statement', style: TextStyle(fontSize: 12)),
    );
  }

  TextButton _buildTermsLink(BuildContext context) {
    return TextButton(
      onPressed: () =>
          _pushFullScreenDialog(context, utils.AssetsPath.txtTermsOfUse, title: 'Terms of service'),
      child: const Text('terms of service', style: TextStyle(fontSize: 12)),
    );
  }

  void _pushFullScreenDialog(
    BuildContext context,
    String textAssetPath, {
    String title = 'Privacy statement',
  }) {
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return PrivacyTermsView(title, rootBundle.loadString(textAssetPath));
        },
        fullscreenDialog: true));
  }
}
