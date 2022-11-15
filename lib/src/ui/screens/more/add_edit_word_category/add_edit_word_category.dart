import 'package:davar/src/data/models/models.dart';
import 'package:flutter/material.dart';

class AddEditWordCategory extends StatefulWidget {
  const AddEditWordCategory(
      {Key? key,
      required this.title,
      required this.onConfirmation,
      required this.onChangeHandle,
      this.category})
      : super(key: key);

  final String title;
  final VoidCallback onConfirmation;
  final ValueChanged<String> onChangeHandle;
  final WordCategory? category;

  @override
  State<AddEditWordCategory> createState() => _AddEditWordCategoryState();
}

class _AddEditWordCategoryState extends State<AddEditWordCategory> {
  late GlobalKey<FormState> _addEditCategoryFormKey;
  late String header;
  late VoidCallback onSubmit;
  late ValueChanged<String> onChangeHandle;
  WordCategory? category;
  String errorInfo = '';

  @override
  void initState() {
    super.initState();
    _addEditCategoryFormKey = GlobalKey<FormState>();
    header = widget.title;
    onSubmit = widget.onConfirmation;
    onChangeHandle = widget.onChangeHandle;
    category = widget.category;
    errorInfo = '';
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _addEditCategoryFormKey,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextFormField(
          decoration: const InputDecoration(hintText: 'new category'),
          initialValue: category != null ? category!.name : '',
          keyboardType: TextInputType.text,
          onChanged: (e) => onChangeHandle(e),
          autocorrect: false,
          validator: (v) {
            if (v == null || v.isEmpty) return 'Cannot be empty!';
            return null;
          },
        ),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          TextButton(onPressed: () => _onSubmit(context), child: Text('Save')),
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancel')),
        ]),
        errorInfo.isEmpty
            ? const SizedBox()
            : Text(
                errorInfo,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 12.0),
              ),
      ]),
    );
  }

  void _onSubmit(BuildContext context) {
    if (_addEditCategoryFormKey.currentState == null) {
      // context.read<LoginProvider>().loginErrorMsg = 'Please try again from the beginning';
      print('_addEditCategoryFormKey.currentState == null');
      setState(() {
        errorInfo = 'Sorry! Category cannot be saved.';
      });
      return;
    }
    if (_addEditCategoryFormKey.currentState!.validate()) {
      _addEditCategoryFormKey.currentState!.save();
      print('form state is valid');
      onSubmit();
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      errorInfo = 'Sorry! Category is not saved.\nClose this window and try again';
    });
  }
}
