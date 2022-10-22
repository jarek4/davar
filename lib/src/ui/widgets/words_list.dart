
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/providers/providers.dart';
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WordsList extends StatelessWidget {
  const WordsList({Key? key, required itemsToDisplay, cardOnTap})
      : _itemsToDisplay = itemsToDisplay,
        _cardOnTap = cardOnTap,
        super(key: key);

  final List<Word> _itemsToDisplay;
  final Function(BuildContext context, Word item)? _cardOnTap;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int i) {
          Word item = _itemsToDisplay[i];
          return WordItem(
              key: Key('WordsListScreen-wordsListItem-${item.id}'),
              item: item,
              favHandle: () =>
                  context.read<WordsProvider>().triggerFavorite(item.id),
              deleteHandle: () => context.read<WordsProvider>().delete(item.id),
              onTapHandle: () {
                if (_cardOnTap == null) {
                  /*context.router.push(EditWordRoute(word: _item, id: _item.id));*/
                } else {
                  _cardOnTap!(context, item);
                }
              });
        },
        childCount: _itemsToDisplay.length,
      ),
    );
  }
}