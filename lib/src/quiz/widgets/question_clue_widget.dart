import 'package:flutter/material.dart';

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

  //final ValueChanged<bool> onChanged;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final bool isClueAdded = clue != null && clue!.isNotEmpty;
    return ExpandableListTile(
      onExpandPressed: () => onChanged(),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text('Clue',
              style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600),
              textAlign: TextAlign.start),
          Text('takes 2 points',
              style: TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.w600),
              textAlign: TextAlign.start),
        ],
      ),
      isTileExpanded: isExpended,
      child: Center(
        child: Text(isClueAdded ? clue! : 'The clue has not been added 🥴',
            style: const TextStyle(fontSize: 16, color: Colors.black), textAlign: TextAlign.center),
      ),
    );
  }
}
