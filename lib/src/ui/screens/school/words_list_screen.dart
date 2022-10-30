import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/providers/providers.dart';
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'custom_search/custom_search.dart';

class WordsListScreen extends StatelessWidget {
  const WordsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12.0),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Expanded(child: SizedBox()),
          Consumer2<CategoriesProvider, FilteredWordsProvider>(
              builder: (BuildContext context, CategoriesProvider cp, FilteredWordsProvider fwp, _) {
            final bool hasErrorMsg = cp.categoriesErrorMsg.isNotEmpty;
            if (hasErrorMsg) utils.showSnackBarInfo(context, msg: cp.categoriesErrorMsg);
            return CategoriesFilter(
              cp.filterCategories,
              fwp.selected,
              (WordCategory? c) =>
                  context.read<FilteredWordsProvider>().onCategoryChange(c),
            );
          }),
          const SizedBox(width: 4.0),
          Consumer<FilteredWordsProvider>(builder: (BuildContext context, FilteredWordsProvider fwp, _) {
            // final bool hasErrorMsg = wp.wordsErrorMsg.isNotEmpty;
            // if (hasErrorMsg) utils.showSnackBarInfo(context, msg: wp.wordsErrorMsg);
            return FavoriteFilter(
              isChecked: fwp.selectedOnlyFavorite,
              onChangeHandle: () => fwp.onOnlyFavoriteChange(),
            );
          }),
          const SizedBox(width: 4.0),
          Consumer<WordsProvider>(builder: (BuildContext context, WordsProvider wp, _) {
            final bool hasErrorMsg = wp.wordsErrorMsg.isNotEmpty;
            if (hasErrorMsg) utils.showSnackBarInfo(context, msg: wp.wordsErrorMsg);
            return SearchFilter(() => showSearch(context: context, delegate: WordSearchDelegate()));
          }),
          const Expanded(child: SizedBox()),
        ]),
        const Divider(),
        const Flexible(
          child: PaginatedItemsList(),
        ),
      ],
    );
  }

  Widget _buildWordsList(context, List<Word> words) {
    List<Word> itemsToDisplay = words;
    late List<Word> filteredItems;
    const bool onlyFav = 1 == 8 - 4;
    if (onlyFav) {
      filteredItems = List.of(itemsToDisplay)..removeWhere((e) => e.isFavorite == 0);
    } else {
      filteredItems = itemsToDisplay;
    }
    if (words.isEmpty) return SliverList(delegate: SliverChildListDelegate([_emptyListInfo()]));
    return const PaginatedItemsList();
    /*return WordsList(
      itemsToDisplay: filteredItems,
      // cardOnTap: (BuildContext ctx, Word item) =>
      //     ctx.router.push(EditWordRoute(word: item, id: item.id)),
    );*/
  }

  Widget _emptyListInfo() => Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Column(children: const [
            Divider(indent: 60.0, endIndent: 60.0, thickness: 1.2),
            Text('Your word\'s list is empty'),
            SizedBox(height: 5.0),
            Text('Add word or sentence! Use the + below.'),
            Divider(indent: 60.0, endIndent: 60.0, thickness: 1.2),
          ]),
        ),
      );
}