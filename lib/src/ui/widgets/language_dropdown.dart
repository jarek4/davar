import 'package:davar/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageDropdown<T> extends StatelessWidget {
  final String hintText;
  final List<T> options;
  final T value;
  final String Function(T) getLabel;
  final void Function(T?) onChanged;

  const LanguageDropdown({
    required Key key,
    this.hintText = 'Select language',
    this.options = const [],
    required this.getLabel,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String select = AppLocalizations.of(context)?.chooseLang ?? 'Please choose language';
    return FormField<T>(
      key: key,
      builder: (FormFieldState<T> state) {
        return InputDecorator(
          decoration: inputDecoration(type: InputType.nativeLAng, label: hintText),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              elevation: 16,
              hint: Text(hintText),
              value: value,
              isDense: true,
              isExpanded: true,
              onChanged: onChanged,
              items: options.map<DropdownMenuItem<T>>((T value) {
                return DropdownMenuItem<T>(
                  key: Key('DropdownMenuItem-$value'),
                  value: value,
                  child: Text(getLabel(value)),
                );
              }).toList(),
            ),
          ),
        );
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (v) => (value == null || value == '') ? select : null,
    );
  }
}
