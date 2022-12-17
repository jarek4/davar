import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SmallUserDialog extends StatelessWidget {
  const SmallUserDialog(this._information, this._onConfirm, {Key? key}) : super(key: key);

  final String _information;
  final Function _onConfirm;

  @override
  Widget build(BuildContext context) {
    final String close = utils.capitalize(AppLocalizations.of(context)?.close ?? 'Close');
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
        border: Border.all(color: Colors.blue, width: 1.4),
      ),
      child: Row(children: [
        Expanded(
          child: Text(_information, softWrap: false, maxLines: 3, overflow: TextOverflow.ellipsis),
        ),
        TextButton(
            onPressed: () => _onConfirm(),
            child: Text(
              close,
              style: const TextStyle(color: Colors.blue),
            ))
      ]),
    );
  }
}
