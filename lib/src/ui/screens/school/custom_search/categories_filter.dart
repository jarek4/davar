import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/theme/theme.dart' as theme;
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';

class CategoriesFilter extends StatelessWidget {
  const CategoriesFilter(this.categories, this.selected, this.handleOnChange, {Key? key})
      : super(key: key);

  final List<WordCategory> categories;
  final WordCategory selected;
  final ValueChanged<WordCategory?> handleOnChange;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                  elevation: 16,
                  isExpanded: true,
                  hint: const Text('all', style: TextStyle(fontSize: 13.0)),
                  value: selected,
                  isDense: true,
                  onChanged: (WordCategory? v) => handleOnChange(v),
                  items: _buildMenuItems()),
            ),
          ),
        ));
  }

  List<DropdownMenuItem<WordCategory>> _buildMenuItems() {
    return categories.map<DropdownMenuItem<WordCategory>>((WordCategory c) {
      return DropdownMenuItem<WordCategory>(
          key: Key('DropdownMenuItem-$c'),
          value: c,
          child: Text(utils.trimTextIfLong(c.name),
              style: const TextStyle(fontSize: 13.0), overflow: TextOverflow.fade));
    }).toList();
  }
}
