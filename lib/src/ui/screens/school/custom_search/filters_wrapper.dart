import 'package:flutter/material.dart';

class FiltersWrapper extends StatelessWidget {
  const FiltersWrapper(
      {Key? key,
        required this.onlyFavoriteCheckbox,
        required this.fromNewestRadio,
        required this.fromOldestRadio})
      : super(key: key);
  final Checkbox onlyFavoriteCheckbox;
  final Radio fromNewestRadio;
  final Radio fromOldestRadio;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(4.0, 4.0, 10.0, 0.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  border: Border.all()),
              child: Row(children: [
                const Expanded(
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.only(left: 4.0),
                      child: Text('Favorites'),
                    )),
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(right: 2.0),
                        child: onlyFavoriteCheckbox))
              ]),
            ),
          )),
      // const Expanded(child: SizedBox()),
      const Expanded(
        child: Text('First: ', style: TextStyle(fontWeight: FontWeight.bold)),
      ),

      // ----------------
      Expanded(
          flex: 2,
          child: Row(
            children: [
              const Expanded(child: SizedBox()),
              const Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.only(right: 4.0),
                    child: Text(
                      'new',
                      style: TextStyle(color: Colors.indigo),
                    ),
                  )),
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: fromNewestRadio),
              ),
              const Expanded(child: SizedBox()),
            ],
          )),

      /// --------------------
      Expanded(
          flex: 2,
          child: Row(
            children: [
              const Expanded(child: SizedBox()),
              const Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.only(left: 4.0),
                    child: Text(
                      'old',
                      style: TextStyle(color: Colors.indigo),
                    ),
                  )),
              Expanded(child: fromOldestRadio),
              const Expanded(child: SizedBox()),
            ],
          )),
    ]);
  }
}
