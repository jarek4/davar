import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/edit_word/edit_word.dart';
import 'package:davar/src/providers/providers.dart';
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<SearchWordsProvider>(context, listen: false).updateStream();
    });
  }

  @override
  void dispose() {
    super.dispose();
    Provider.of<SearchWordsProvider>(context, listen: false).dispose();
  }

  void loadMore({isUpdate = false}) {
    Provider.of<SearchWordsProvider>(context, listen: false).filter();
  }

  @override
  Widget build(BuildContext context) {
    bool hasErrorMsg =
        Provider.of<SearchWordsProvider>(context, listen: false).errorMsg.isNotEmpty;
    if (hasErrorMsg) {
      utils.showSnackBarInfo(context,
          msg: Provider.of<SearchWordsProvider>(context, listen: false).errorMsg);
    }
    return StreamBuilder<List<Word>?>(
      stream: Provider.of<SearchWordsProvider>(context, listen: false).filteredWords,
      initialData: const [],
      builder: (BuildContext context, AsyncSnapshot<List<Word>?> snapshot) {
        print('StreamBuilder state ${snapshot.connectionState}');
        final bool isWaiting = snapshot.connectionState == ConnectionState.waiting;
        if (snapshot.hasError) utils.showSnackBarInfo(context, msg: snapshot.error.toString());
        if (!snapshot.hasData) return _buildNoData(isNullSnapshot: true);
        final List<Word> data = snapshot.data ?? [];
        if (data.isEmpty) return _buildNoData();
        return _buildItemsList(data, isWaiting);
      },
    );
  }

  ListView _buildItemsList(List<Word> data, bool isWaiting) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: data.length + 1,
      itemBuilder: (context, index) {
        // if (data.isEmpty) return _buildNoData();
        return (index == data.length)
            ? _buildLoadMoreTextBtn(isWaiting: isWaiting)
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
    final Word? result = await Navigator.push<Word>(
      context,
      MaterialPageRoute(builder: (context) => EditWordView(editing)),
    );
    return result;
  }

  Widget _buildNoData({bool isNullSnapshot = false}) {
    // or OverflowBar ?
    return Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8.0,
        children: [
          const Text('Nothing was found.'),
          _buildLoadMoreTextBtn(text: 'Try again'),
          isNullSnapshot ? const Text('Maybe your word\'s list is empty 😯') : const SizedBox()
        ]);
  }

  Widget _buildLoadMoreTextBtn({String text = 'Load More', bool isWaiting = false}) {
    return Center(
      child: TextButton(
          onPressed: isWaiting ? null : () => loadMore(),
          child:
              isWaiting ? const Center(child: CircularProgressIndicator.adaptive()) : Text(text)),
    );
  }
}
