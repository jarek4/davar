import 'dart:collection';

import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/edit_word/edit_word.dart';
import 'package:davar/src/providers/providers.dart';
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

/// Need initState for updating StreamBuilder. When list item is edited then also data in
/// Stream builder need to be updated
class PaginatedStreamList extends StatefulWidget {
  const PaginatedStreamList({Key? key}) : super(key: key);
  static const routeName = '/items_list';

  @override
  State<PaginatedStreamList> createState() => _PaginatedStreamListState();
}

class _PaginatedStreamListState extends State<PaginatedStreamList> {
  @override
  void didChangeDependencies() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<SearchWordsProvider>(context, listen: false).updateStream();
    });
    super.didChangeDependencies();
  }

  void _loadMore() {
    Provider.of<SearchWordsProvider>(context, listen: false).filter();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UnmodifiableListView<Word>?>(
      stream: Provider.of<SearchWordsProvider>(context, listen: false).filteredWords,
      initialData: UnmodifiableListView<Word>([]),
      builder: (BuildContext context, AsyncSnapshot<UnmodifiableListView<Word>?> snapshot) {
        final bool isWaiting = snapshot.connectionState == ConnectionState.waiting;
        if (snapshot.hasError) utils.showSnackBarInfo(context, msg: snapshot.error.toString());
        if (!snapshot.hasData) return _buildNoData(isNullSnapshot: true);
        final UnmodifiableListView<Word> data = snapshot.data ?? UnmodifiableListView<Word>([]);
        if (data.isEmpty) return _buildNoData();
        return _buildItemsList(data, isWaiting);
      },
    );
  }

  ListView _buildItemsList(UnmodifiableListView<Word> data, bool isWaiting) {
    final String more = AppLocalizations.of(context)?.loadMore ?? 'Load more';
    return ListView.builder(
      shrinkWrap: true,
      itemCount: data.length + 1,
      itemBuilder: (context, index) {
        return (index == data.length)
            ? _buildLoadMoreTextBtn(text: more, isWaiting: isWaiting)
            : WordItem(
                item: data[index],
                favHandle: () => _onFavoriteChange(data[index]),
                deleteHandle: () => _onDelete(data[index].id),
                onTapHandle: () => _onItemTap(data[index]));
      },
    );
  }

  Future<void> _onDelete(int id) async {
    await Provider.of<SearchWordsProvider>(context, listen: false).delete(id);
  }

  Future<void> _onFavoriteChange(Word word) async {
    await Provider.of<SearchWordsProvider>(context, listen: false).toggleFavorite(word);
  }

  Future<void> _onItemTap(Word editing) async {
    final Word? result = await _navigateToEditPage(editing);
    if (!mounted) return;
    // word was not changed (result == editing)
    if (result == null || result == editing) return;
    Provider.of<SearchWordsProvider>(context, listen: false).updateState(result);
  }

  Future<Word?> _navigateToEditPage(Word editing) async {
    CategoriesProvider cp = Provider.of<CategoriesProvider>(context, listen: false);
    final Word? result = await Navigator.push<Word>(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<CategoriesProvider>.value(
              value: cp, child: EditWordView(editing)),
        ));
    return result;
  }

  Widget _buildNoData({bool isNullSnapshot = false}) {
    final String nothing = AppLocalizations.of(context)?.nothingFound ?? 'Nothing was found';
    final String empty = '${AppLocalizations.of(context)?.listEmpty} 😯';
    final String again = AppLocalizations.of(context)?.tryAgain ?? 'Try again';
    // or OverflowBar ?
    return Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8.0,
        children: [
          Text(nothing),
          _buildLoadMoreTextBtn(text: again),
          isNullSnapshot ? Text(empty) : const SizedBox()
        ]);
  }

  Widget _buildLoadMoreTextBtn({required String text, bool isWaiting = false}) {
    return Center(
      child: TextButton(
          onPressed: isWaiting ? null : () => _loadMore(),
          child:
              isWaiting ? const Center(child: CircularProgressIndicator.adaptive()) : Text(text)),
    );
  }
}
