import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FullScreenProgressIndicator extends StatelessWidget {
  const FullScreenProgressIndicator({Key? key, this.additionalErrorMessage, this.actionButton})
      : super(key: key);
  final String? additionalErrorMessage;
  final Widget? actionButton;

  String _makeInfo(BuildContext context, String? info) {
    final String moreInfo =
        AppLocalizations.of(context)?.moreInfo.toUpperCase() ?? 'MORE INFORMATION';
    final String something =
        AppLocalizations.of(context)?.someThingHappened ?? 'Something has happened';
    String msg = '🧐 hmm... \n$something\n - - - -\n$moreInfo:\n';
    if (info != null && info.isNotEmpty) {
      return msg = '$msg$info';
    }
    return msg = '';
  }

  @override
  Widget build(BuildContext context) {
    final String loading = AppLocalizations.of(context)?.loading ?? 'Loading';
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          const SizedBox(
              height: 40,
              width: 40,
              child: CircularProgressIndicator(
                backgroundColor: Colors.black12,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              )),
          const SizedBox(height: 5),
          Text(loading),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(_makeInfo(context, additionalErrorMessage),
                textAlign: TextAlign.center, style: const TextStyle(height: 2.0)),
          ),
          if (actionButton != null)
            Column(children: [
              const SizedBox(height: 5),
              actionButton!,
            ])
        ]),
      ),
    );
  }
}
