import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/theme/theme.dart' as theme;
import 'package:davar/src/ui/screens/school/custom_search/word_search_delegate.dart';
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';

class FiltersBar extends StatefulWidget {
  const FiltersBar({Key? key, required handleOnlyFavorite, required handleOrder})
      : _handleOnlyFavorite = handleOnlyFavorite,
        _handleOrder = handleOrder,
        super(key: key);
  final Function _handleOnlyFavorite, _handleOrder;

  @override
  State<FiltersBar> createState() => _FiltersBarState();
}

class _FiltersBarState extends State<FiltersBar> {
  late bool _onlyFavoriteCheckboxValue;
  late bool _isOrderedFromOldest;

  List<WordCategory> categ = [
    const WordCategory(id: 11, userId: 2, name: 'no category'),
    const WordCategory(id: 12, userId: 2, name: 'animals'),
    const WordCategory(id: 13, userId: 2, name: 'family jhygfr nhhhyyhbg')
  ];

  @override
  void initState() {
    _onlyFavoriteCheckboxValue = false;
    _isOrderedFromOldest = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 6.0),
        _buildSelectCategory(),
        const SizedBox(width: 6.0),
        // _buildFavoriteFilter(),
        _buildFavoriteOrSearchBox(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 4.0),
            const Text(
              'only',
              style: TextStyle(fontSize: 13.0),
            ),
            Icon(Icons.favorite, color: Colors.red.withOpacity(0.5), size: 16.0),
            Checkbox(
              activeColor: Colors.green.shade400,
              value: _onlyFavoriteCheckboxValue,
              onChanged: (bool? value) {
                setState(() {
                  _onlyFavoriteCheckboxValue = !_onlyFavoriteCheckboxValue;
                });
                widget._handleOnlyFavorite(_onlyFavoriteCheckboxValue);
              },
            ),
          ],
        )),
        const SizedBox(width: 6.0),
        _buildFavoriteOrSearchBox(
          TextButton(
            onPressed: () => showSearch(context: context, delegate: WordSearchDelegate()),
            child: Row(children: const [
              SizedBox(width: 2.0),
              Text('Search'),
              Icon(Icons.search, size: 18.0),
              SizedBox(width: 2.0),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteFilter() => SizedBox(
      height: 40.0,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            border: Border.all(color: const Color(0xff0E9447))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 4.0),
            const Text(
              'only',
              style: TextStyle(fontSize: 13.0),
            ),
            Icon(Icons.favorite, color: Colors.red.withOpacity(0.5), size: 16.0),
            Checkbox(
              activeColor: Colors.green.shade400,
              value: _onlyFavoriteCheckboxValue,
              onChanged: (bool? value) {
                setState(() {
                  _onlyFavoriteCheckboxValue = !_onlyFavoriteCheckboxValue;
                });
                widget._handleOnlyFavorite(_onlyFavoriteCheckboxValue);
              },
            ),
          ],
        ),
      ));

  Widget _buildSearchBtn() => SizedBox(
      height: 40.0,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            border: Border.all(color: const Color(0xff0E9447))),
        child: TextButton(
          onPressed: () => showSearch(context: context, delegate: WordSearchDelegate()),
          child: Row(children: const [
            SizedBox(width: 2.0),
            Text('Search'),
            Icon(Icons.search, size: 18.0),
            SizedBox(width: 2.0),
          ]),
        ),
      ));

  Widget _buildFavoriteOrSearchBox(Widget child, {double? h = 40.0, double? w}) => SizedBox(
      height: h,
      width: w,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            border: Border.all(color: const Color(0xff0E9447))),
        child: child,
      ));

  // WordCategory.name is max. 20 characters! need to be trimmed to 15
  Widget _buildSelectCategory() => SizedBox(
      height: 40.0,
      width: 130,
      child: Container(
        padding: const EdgeInsets.only(left: 4.0),
        alignment: Alignment.center,
        child: InputDecorator(
          decoration: theme.smallInputDecoration(label: 'categories'),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<WordCategory>(
              iconSize: 20.0,
              dropdownColor: Colors.amberAccent,
              elevation: 16,
              // utils.trimTextIfLong()
              hint: const Text(
                'all',
                style: TextStyle(fontSize: 13.0),
              ),
              value: null,
              isDense: true,
              onChanged: (WordCategory? v) {},
              items: categ.map<DropdownMenuItem<WordCategory>>((WordCategory c) {
                return DropdownMenuItem<WordCategory>(
                  key: Key('DropdownMenuItem-$c'),
                  value: c,
                  child: Text(utils.trimTextIfLong(c.name), style: const TextStyle(fontSize: 13.0)),
                );
              }).toList(),
            ),
          ),
        ),
      ));
}
