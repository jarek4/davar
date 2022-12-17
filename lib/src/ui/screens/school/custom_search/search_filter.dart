import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchFilter extends StatelessWidget {
  const SearchFilter(this.onSearch, {Key? key}) : super(key: key);

  final Function onSearch;

  @override
  Widget build(BuildContext context) {
    final String s = utils.capitalize(AppLocalizations.of(context)?.listSearch ?? 'Search');
    return SizedBox(
        height: 40.0,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              border: Border.all(color: const Color(0xff0E9447))),
          child: TextButton(
            onPressed: () => onSearch(),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const SizedBox(width: 2.0),
              Text(s),
              const SizedBox(width: 2.5),
              const Icon(Icons.search, size: 18.0),
              const SizedBox(width: 2.0),
            ]),
          ),
        ));
  }
}
