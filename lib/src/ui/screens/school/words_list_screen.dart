import 'package:davar/src/authentication/authentication.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/providers/providers.dart';
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
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
      Consumer<WordsProvider>(
        builder: (BuildContext context, WordsProvider provider, _) => _buildWordListWidget(context, provider),
      )
    ]);
  }
  Widget _buildWordListWidget(context, WordsProvider state) {
    /// TODO: check for state.status - if failure show state.errorText
    /// if user has no permission show state.errorText
    List<Word> itemsToDisplay = state.words;
    late List<Word> filteredItems;
    const bool onlyFav = 1 == 8-4;
    if (onlyFav) {
      filteredItems = List.of(itemsToDisplay)
        ..removeWhere((e) => e.isFavorite == 0);
    } else {
      filteredItems = itemsToDisplay;
    }
    return WordsList(
      itemsToDisplay: filteredItems,
      // cardOnTap: (BuildContext ctx, Word item) =>
      //     ctx.router.push(EditWordRoute(word: item, id: item.id)),
    );
  }

  Column _buildScreenBody(
      BuildContext context, String name, int id, String native, String learning) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Expanded(
        flex: 1,
        child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            key: const Key('ProfileScreen-signed in'),
            shrinkWrap: true,
            children: [
              ListTile(
                title: Text('Name: $name'),
                leading: const Icon(Icons.person_outline),
              ),
              ListTile(
                title: Text('user id: $id'),
                leading: const Icon(Icons.email_outlined),
              ),
              const Divider(thickness: 1.2),
            ]),
      ),
    /*Expanded(
      flex: 2,
      child: Consumer<WordsProvider>(builder: (BuildContext context, WordsProvider provider, _){
              return FutureBuilder<List<Word>>(
                  future: provider.words,
                  builder: (BuildContext ctx, AsyncSnapshot<List<Word>> snapshot) {
                    ConnectionState st = snapshot.connectionState;
                    if (snapshot.hasError) {
                      return ListView(
                        // scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        children: [
                          Text('Error ${snapshot.error.toString()}'),
                          const SizedBox(height: 30, child: CircularProgressIndicator())
                        ],
                      );
                    } else if (st == ConnectionState.done && snapshot.hasData) {
                      List<Word> data = snapshot.data!;
                      return ListView.builder(
                          // scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          key: const Key('You-CustomizeScreen-categories-list'),
                          shrinkWrap: true,
                          itemCount: data.length,
                          // separatorBuilder: (context, index) => const Divider(
                          //       thickness: 1.2,
                          //     ),
                          itemBuilder: (context, index) {
                            return Column(
                                mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('word id: ${data[index].id}'),
                                Text('category id: ${data[index].categoryId}'),
                                Text('category: ${data[index].category}'),
                                Text('user id: ${data[index].userId}'),
                                const Divider(),
                              ],
                            );
                          });
                    } else {
                      {
                        return ListView(
                          shrinkWrap: true,
                          children: const [
                            Center(child: SizedBox(height: 30, child: CircularProgressIndicator()))
                          ],
                        );
                      }
                    }
                  });
            }),
    ),*/
      /*Expanded(
        flex: 2,
        child: Consumer<WordsProvider>(builder: (BuildContext context, WordsProvider provider, _) {
          switch (provider.status) {
            case WordsProviderStatus.success:
              return Center(child: Text(provider.status.toString()));
              return FutureBuilder<List<Word>>(
                future: provider.words, // async work
                builder: (BuildContext context, AsyncSnapshot<List<Word>> snapshot) {
                  ConnectionState st = snapshot.connectionState;
                  switch (st) {
                    case ConnectionState.waiting:
                      return const Text('Loading....');
                    case ConnectionState.done:
                      print('snapshot.connectionState = ${snapshot.connectionState}');
                      print('snapshot.hasData = ${snapshot.hasData}');
                      if(snapshot.hasData && snapshot.data != null) {
                        return _buildList(context, snapshot.data ?? []);
                      }
                      return const Text('Error:snapshot.hasNotData or snapshot.data == null');
                    default:
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Text('Result: ${snapshot.data}');
                      }
                  }
                },
              );
            default:
              return Center(
                child: Text('provider.status = ${provider.status}')
              );
          }
        }),
      ),*/
    ]);
  }

  Widget _buildList(BuildContext context, List<Word> words) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: words.length,
        itemBuilder: (context, index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(words[index].catchword),
              Text('Id: ${words[index].id}'),
              Text('category: ${words[index].category}'),
              Text('categoryId: ${words[index].categoryId}'),
            ],
          );
        });
  }
}
