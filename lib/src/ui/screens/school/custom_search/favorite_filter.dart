import 'package:flutter/material.dart';

class FavoriteFilter extends StatelessWidget {
  const FavoriteFilter({Key? key, required this.isChecked, required this.onChangeHandle})
      : super(key: key);

  final bool isChecked;
  final Function onChangeHandle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.0,
      child: ChoiceChip(
        label: const FittedBox(child: Text('Favorites')),
        elevation: 4.8,
        selectedShadowColor: Colors.red,
        side: BorderSide(color: isChecked ? Colors.red : const Color(0xff0E9447)),
        selected: isChecked,
        onSelected: (v) => onChangeHandle(),
      ),
    );
  }
}
