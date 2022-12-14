import 'dart:collection';

import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/providers/providers.dart';
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WordSearchDelegate extends SearchDelegate<Word?> {
  WordSearchDelegate(this.provider);

  final SearchWordsProvider provider;

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.blueAccent)),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      // clear the query - input (right end of the search bar)
      IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () async {
            if (query.isEmpty) {
              // close and leave search bar
              close(context, null);
            } else {
              query = '';
            }
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // to leave and close search bar, back to prev screen (left side)
    return Container();
  }

  Widget buildLoadingIndicator(BuildContext context) {
    final String loading = AppLocalizations.of(context)?.loading ?? 'Loading...';
    return Center(
      child: Column(
        children: [const CircularProgressIndicator.adaptive(), Text(loading)],
      ),
    );
  }

  LayoutBuilder _layoutBuilderWrapper(Widget child) {
    return LayoutBuilder(builder: (context, constraint) {
      final bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
      final double maxWidth = constraint.maxWidth;
      final double landscapeMaxW = (maxWidth * 3) / 4;
      return SizedBox(width: isPortrait ? maxWidth - 30 : landscapeMaxW, child: child);
    });
  }

  ListView _buildItemsList(UnmodifiableListView<Word> data, Function onItemTap, bool isWaiting) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, index) {
        return WordItem(
            item: data[index],
            favHandle: () {},
            deleteHandle: () {},
            onTapHandle: () => onItemTap(context, data[index]));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    const String addToList = 'Which element you want to add\n at the beginning of the main list?';
    final String toTheTopOfTheList = AppLocalizations.of(context)?.listAddListTop ?? addToList;
    final String empty =
        AppLocalizations.of(context)?.listEmpty ?? 'Maybe your word\'s list is empty';
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          toTheTopOfTheList,
          style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      const Divider(height: 13.0, thickness: 1.4),
      Expanded(
        child: _layoutBuilderWrapper(StreamBuilder<UnmodifiableListView<Word>?>(
          stream: provider.querySearch(query),
          initialData: UnmodifiableListView<Word>([]),
          builder: (BuildContext context, AsyncSnapshot<UnmodifiableListView<Word>?> snapshot) {
            final bool isWaiting = snapshot.connectionState == ConnectionState.waiting;
            if (isWaiting) return buildLoadingIndicator(context);
            if (snapshot.hasError) {
              utils.showSnackBarInfo(context, msg: snapshot.error.toString());
            }
            if (!snapshot.hasData) return Text('$empty ????');
            final UnmodifiableListView<Word> data = snapshot.data ?? UnmodifiableListView<Word>([]);
            if (data.isEmpty) return _buildEmptyData(context);
            return _buildItemsList(data, _onResultTap, isWaiting);
          },
        )),
      )
    ]);
  }

  void _onResultTap(BuildContext context, Word item) async {
    close(context, item);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final String empty =
        AppLocalizations.of(context)?.listEmpty ?? 'Maybe your word\'s list is empty';
    return Container(
      alignment: Alignment.center,
      child: _layoutBuilderWrapper(StreamBuilder<UnmodifiableListView<Word>?>(
        stream: provider.querySearch(query),
        initialData: UnmodifiableListView<Word>([]),
        builder: (BuildContext context, AsyncSnapshot<UnmodifiableListView<Word>?> snapshot) {
          final bool isWaiting = snapshot.connectionState == ConnectionState.waiting;
          if (snapshot.hasError) utils.showSnackBarInfo(context, msg: snapshot.error.toString());
          if (!snapshot.hasData) return Text('$empty ????');
          final UnmodifiableListView<Word> data = snapshot.data ?? UnmodifiableListView<Word>([]);
          if (data.isEmpty) return _buildEmptyData(context);
          return _buildItemsList(data, _onSuggestionTap, isWaiting);
        },
      )),
    );
  }

  void _onSuggestionTap(BuildContext context, Word item) {
    query = item.catchword;
    showResults(context);
  }

  Widget _buildEmptyData(BuildContext context) {
    final String nothing = AppLocalizations.of(context)?.nothingFound ?? 'Nothing was found.';
    return Center(
      child: Text(nothing),
    );
  }
}
