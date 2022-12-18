import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddEditWordCategory extends StatefulWidget {
  const AddEditWordCategory(
      {Key? key, required this.onConfirmation, required this.onChangeHandle, this.category})
      : super(key: key);

  final VoidCallback onConfirmation;
  final ValueChanged<String> onChangeHandle;
  final WordCategory? category;

  @override
  State<AddEditWordCategory> createState() => _AddEditWordCategoryState();
}

class _AddEditWordCategoryState extends State<AddEditWordCategory> {
  late GlobalKey<FormState> _addEditCategoryFormKey;

  late VoidCallback _onSubmit;
  late ValueChanged<String> _onChangeHandle;
  WordCategory? _category;
  String _errorInfo = '';

  @override
  void initState() {
    super.initState();
    _addEditCategoryFormKey = GlobalKey<FormState>();
    _onSubmit = widget.onConfirmation;
    _onChangeHandle = widget.onChangeHandle;
    _category = widget.category;
    _errorInfo = '';
  }

  @override
  Widget build(BuildContext context) {
    final String c = AppLocalizations.of(context)?.category ?? 'new category';
    final String empty = AppLocalizations.of(context)?.fieldNotEmpty ?? 'Cannot be empty';
    final String save = utils.capitalize(AppLocalizations.of(context)?.save ?? 'Save');
    final String cancel = utils.capitalize(AppLocalizations.of(context)?.cancel ?? 'Cancel');
    return Form(
      key: _addEditCategoryFormKey,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextFormField(
          maxLength: 20,
          decoration: InputDecoration(hintText: c),
          initialValue: _category != null ? _category!.name : '',
          keyboardType: TextInputType.text,
          onChanged: (e) => _onChangeHandle(e),
          autocorrect: false,
          validator: (v) {
            if (v == null || v.isEmpty) return empty;
            return null;
          },
        ),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          TextButton(onPressed: () => _handleSubmit(context), child: Text(save)),
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(cancel)),
        ]),
        _errorInfo.isEmpty
            ? const SizedBox()
            : Text(
                _errorInfo,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 12.0),
              ),
      ]),
    );
  }

  void _handleSubmit(BuildContext context) {
    final String category = AppLocalizations.of(context)?.category ?? 'Category';
    final String notSaved = AppLocalizations.of(context)?.notSaved ?? 'cannot be saved';
    final String again = AppLocalizations.of(context)?.tryAgain ?? 'try again';
    if (_addEditCategoryFormKey.currentState == null) {
      setState(() {
        _errorInfo = '$category $notSaved.';
      });
      return;
    }
    if (_addEditCategoryFormKey.currentState!.validate()) {
      _addEditCategoryFormKey.currentState!.save();
      _onSubmit();
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _errorInfo = '$category $notSaved.\n$again.';
    });
  }
}
