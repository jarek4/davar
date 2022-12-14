import 'package:davar/src/theme/theme.dart';
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';

class DropDownSelect<T> extends StatelessWidget {
  final String hintText;
  final List<T> options;
  final T value;
  final String Function(T) getLabel;
  final void Function(T?) onChanged;

  const DropDownSelect({
    required Key key,
    this.hintText = 'Please select',
    this.options = const [],
    required this.getLabel,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      key: key,
      builder: (FormFieldState<T> state) {
        return InputDecorator(
          decoration: inputDecoration(type: InputType.other, label: hintText),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              dropdownColor: Colors.amberAccent,
              elevation: 16,
              hint: Text(utils.trimTextIfLong(hintText)),
              value: value,
              isDense: true,
              onChanged: onChanged,
              items: options.map<DropdownMenuItem<T>>((T value) {
                return DropdownMenuItem<T>(
                  key: Key('DropdownMenuItem-$value'),
                  value: value,
                  child: Text(utils.trimTextIfLong(getLabel(value))),
                );
              }).toList(),
            ),
          ),
        );
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (v) => (value == null || value == '') ? 'Please select' : null,
    );
  }
}
