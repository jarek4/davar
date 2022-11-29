import 'package:flutter/material.dart';

void showBanner(BuildContext context, String? msg,
    {String? actionButtonText, Function? actionButtonHandle}) {
  final String info = msg ?? 'Ups, something went wrong';
  ScaffoldMessenger.of(context)
    ..removeCurrentMaterialBanner()
    ..showMaterialBanner(_buildMaterialBanner(context, info, actionButtonText, actionButtonHandle));
}

MaterialBanner _buildMaterialBanner(
    BuildContext context, String txt, String? actionButtonText, Function? actionButtonHandle) {
  return MaterialBanner(
    backgroundColor: Theme.of(context).backgroundColor,
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    leading: const Icon(Icons.error),
    content: Text(txt),
    contentTextStyle:
        const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.indigo),
    actions: [
      TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
          },
          child: Text(actionButtonText != null ? 'Cancel' : 'OK',
              style: const TextStyle(color: Colors.purple))),
      if (actionButtonText == null)
        const SizedBox.shrink()
      else
        TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              if (actionButtonHandle != null) {
                actionButtonHandle();
              }
            },
            child: Text(actionButtonText, style: const TextStyle(color: Colors.red))),
    ],
  );
}
