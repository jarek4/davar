import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/providers/providers.dart';
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import 'custom_search/filters_bar.dart';
import 'custom_search/search_header.dart';

class WordsListScreen extends StatelessWidget {
  const WordsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      const SearchHeader(),
      SliverList(
        delegate: SliverChildListDelegate([
          FiltersBar(
            handleOnlyFavorite: () {},
            handleOrder: () {},
            // handleOrder: context.read<WordsProvider>().triggerFavorite(0),
          ),
        ]),
      ),
      Consumer<WordsProvider>(builder: (BuildContext context, WordsProvider provider, _) {
        final bool hasErrorMsg = provider.wordsErrorMsg.isNotEmpty;
        if (hasErrorMsg) _showErrorSnackBar(context, provider.wordsErrorMsg);
        switch (provider.status) {
          case WordsProviderStatus.loading:
            return SliverList(
                delegate:
                    SliverChildListDelegate([const LinearLoadingWidget(info: 'Please wait...')]));
          case WordsProviderStatus.success:
            return _buildWordListWidget(context, provider.words);
          case WordsProviderStatus.error:
            return SliverList(delegate: SliverChildListDelegate([Text(provider.wordsErrorMsg)]));
          default:
            const msg = 'Something has happened. Please try again';
            return SliverList(
                delegate: SliverChildListDelegate([const LinearLoadingWidget(info: msg)]));
        }
      })
    ]);
  }

  Widget _buildWordListWidget(context, List<Word> words) {
    List<Word> itemsToDisplay = words;
    late List<Word> filteredItems;
    const bool onlyFav = 1 == 8 - 4;
    if (onlyFav) {
      filteredItems = List.of(itemsToDisplay)..removeWhere((e) => e.isFavorite == 0);
    } else {
      filteredItems = itemsToDisplay;
    }
    if (words.isEmpty) return SliverList(delegate: SliverChildListDelegate([_emptyListInfo()]));
    return WordsList(
      itemsToDisplay: filteredItems,
      // cardOnTap: (BuildContext ctx, Word item) =>
      //     ctx.router.push(EditWordRoute(word: item, id: item.id)),
    );
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

  void _showErrorSnackBar(BuildContext context, String msg) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg, textAlign: TextAlign.center),
      ));
    });
  }
}
