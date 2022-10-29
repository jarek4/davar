import 'package:flutter/material.dart';

class SearchFilter extends StatelessWidget {
  const SearchFilter(this.onSearch, {Key? key}) : super(key: key);

  final Function onSearch;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 40.0,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              border: Border.all(color: const Color(0xff0E9447))),
          child: TextButton(
            // onPressed: () => showSearch(context: context, delegate: WordSearchDelegate()),
            onPressed: () => onSearch(),
            child: Row(children: const [
              SizedBox(width: 2.0),
              Text('Search'),
              Icon(Icons.search, size: 18.0),
              SizedBox(width: 2.0),
            ]),
          ),
        ));
  }
}
