import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'expendable_list_tile.dart';

class QuestionClueWidget extends StatelessWidget {
  const QuestionClueWidget({
    Key? key,
    required this.clue,
    required this.isExpended,
    required this.onChanged,
  }) : super(key: key);

  final String? clue;
  final bool isExpended;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final String c = AppLocalizations.of(context)?.clue ?? 'Clue';
    final String point1 = AppLocalizations.of(context)?.takesPoint ?? 'takes 1 point';
    final String noClue =
        AppLocalizations.of(context)?.clueNotAdded ?? 'The clue has not been added';
    final bool isClueAdded = clue != null && clue!.isNotEmpty;
    return ExpandableListTile(
      onExpandPressed: () => onChanged(),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(c,
              style:
                  const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600),
              textAlign: TextAlign.start),
          Text(point1,
              style:
                  const TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.w600),
              textAlign: TextAlign.start),
        ],
      ),
      isTileExpanded: isExpended,
      child: Center(
        child: Text(isClueAdded ? clue! : '$noClue 🥴',
            style: const TextStyle(fontSize: 16, color: Colors.black), textAlign: TextAlign.center),
      ),
    );
  }
}
