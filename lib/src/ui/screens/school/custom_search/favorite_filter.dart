import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavoriteFilter extends StatelessWidget {
  const FavoriteFilter({Key? key, required this.isChecked, required this.onChangeHandle})
      : super(key: key);

  final bool isChecked;
  final Function onChangeHandle;

  @override
  Widget build(BuildContext context) {
    final String f = AppLocalizations.of(context)?.favorite ?? 'Favorites';
    return SizedBox(
      height: 40.0,
      child: ChoiceChip(
        label: FittedBox(child: Text(f.padRight(3).padLeft(3))),
        elevation: 4.8,
        selectedShadowColor: Colors.red,
        side: BorderSide(color: isChecked ? Colors.red : const Color(0xff0E9447)),
        selected: isChecked,
        onSelected: (v) => onChangeHandle(),
      ),
    );
  }
}
