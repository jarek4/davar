import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/providers/providers.dart';
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../authentication/authentication.dart';

class WordSearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    // assert(context != null);
    final ThemeData theme = Theme.of(context);
    // theme.copyWith(backgroundColor: Colors.amber);
    // assert(theme != null);
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      // to clear the query - input (right end of the search bar)
      IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              // close and leave search bar
              close(context, null);
            } else {
              // clear the query
              query = '';
            }
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // to leave and close search bar, back to prev screen (left end of the search bar)
    return Container();
  }

  @override
  Widget buildResults(BuildContext context) {
    //Add the search term to the searchBloc.
    //The Bloc will then handle the searching and add the results to the searchResults stream.
    //This is the equivalent of submitting the search term to whatever search service you are using

    return Consumer<WordsProvider>(builder: (BuildContext context, WordsProvider provider, _) {
      switch (provider.status) {
        case WordsProviderStatus.loading:
          return Center(
            child: Column(children: const <Widget>[CircularProgressIndicator(color: Colors.green)]),
          );
        case WordsProviderStatus.success:
          final List<Word> list = provider.words;
          final results =
              list.where((w) => w.userNative.toLowerCase().contains(query.toLowerCase())).toList();
          return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              key: const Key('WordsListScreen-wordsList_builder'),
              itemCount: results.length,
              itemBuilder: (BuildContext context, int index) {
                if (results.isEmpty) {
                  return const Text('You have no words yet', textAlign: TextAlign.center);
                } else {
                  final Word word = results[index];
                  return WordItem(
                      key: Key('WordsListScreen-wordsListItem-${word.id}'),
                      favHandle: () => context.read<WordsProvider>().triggerFavorite(word.id),
                      deleteHandle: () => context.read<WordsProvider>().delete(word.id),
                      item: word);
                }
              });
        case WordsProviderStatus.error:
          return Center(
            child: Column(children: const <Widget>[
              CircularProgressIndicator(
                color: Colors.green,
              ),
              Text('Please, try again. 🙄 😮'),
              Text('Error: ___'),
            ]),
          );
        default:
          return Center(
            child: Column(children: const <Widget>[
              CircularProgressIndicator(color: Colors.red),
              Text('Please, try again. Something go wrong 🙄 😮'),
            ]),
          );
      }
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //called everytime the search term (query) changes.
    return ChangeNotifierProvider<WordsProvider>(
      create: (_) => WordsProvider(context.read<AuthProvider>().user),
      child: CustomScrollView(slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            Column(children: [
              Consumer<WordsProvider>(builder: (BuildContext context, WordsProvider provider, _) {
                if (provider.words.isEmpty) {
                  return const Center(child: Text('No words, add some'));
                }
                final suggestions = provider.words
                    .where((w) => w.catchword.toLowerCase().contains(query.toLowerCase()))
                    .toList();
                return ListView(
                    shrinkWrap: true,
                    children: suggestions
                        .map<Widget>((e) => WordItem(
                            key: Key('WordsListScreen-wordsListItem-${e.id}'),
                            onTapHandle: () {
                              /*'context.router.push(EditWordRoute(word: e, id: e.id))'*/
                            },
                            // onTapHandle: () {
                            //   // when click one suggestion it will put it into the input
                            //   query = e.inNative;
                            //   showResults(context);
                            //   context.router
                            //       .push(EditWordRoute(word: e, id: e.id));
                            // },
                            favHandle: () => context.read<WordsProvider>().triggerFavorite(e.id),
                            deleteHandle: () => context.read<WordsProvider>().delete(e.id),
                            item: e))
                        .toList());
              }),
            ])
          ]),
        ),
      ]),
    );
  }
}
