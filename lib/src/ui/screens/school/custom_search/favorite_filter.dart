import 'package:flutter/material.dart';

class FavoriteFilter extends StatelessWidget {
  const FavoriteFilter({Key? key, required this.isChecked, required this.onChangeHandle}) : super(key: key);

  final bool isChecked;
  final Function onChangeHandle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                value: isChecked,
               onChanged: (v) => onChangeHandle(),
                // onChanged: onChangeHandle,
              ),
            ],
          ),
        ));
  }
}
