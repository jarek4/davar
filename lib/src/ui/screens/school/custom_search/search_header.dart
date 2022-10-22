import 'package:flutter/material.dart';

import 'word_search_delegate.dart';

class SearchHeader extends StatelessWidget {
  const SearchHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SliverAppBar(
      automaticallyImplyLeading: false,
      floating: true,
      snap: true,
      title: const Text('search'),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: WordSearchDelegate());
            }),
      ],
    );
  }
}