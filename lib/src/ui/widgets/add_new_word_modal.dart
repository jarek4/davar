import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/providers/providers.dart';
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AddNewWordModal extends StatefulWidget {
  const AddNewWordModal(
      {Key? key,
      this.isSentence = false,
      required this.categories,
      required this.handleSubmit,
      required this.handleErrorMessage})
      : super(key: key);

  final bool isSentence;
  final List<WordCategory> categories;
  final Function handleSubmit;
  final ValueChanged<String> handleErrorMessage;

  @override
  _AddNewWordModalState createState() => _AddNewWordModalState();
}

class _AddNewWordModalState extends State<AddNewWordModal> {
  final TextEditingController _catchwordCtrl = TextEditingController();
  final TextEditingController _translationCtrl = TextEditingController();
  final TextEditingController _clueCtrl = TextEditingController();
  final GlobalKey<FormState> _addNewWordModalFormKey = GlobalKey<FormState>();
  bool _isFavorite = false;
  String catchword = 'English - demo';
  String userTranslation = 'Polish - demo';
  late WordCategory _selectedCategory;

  @override
  void initState() {
    _isFavorite = false;
    _selectedCategory = widget.categories[0];
    catchword = widget.isSentence ? 'Sentence' : 'Word';
    userTranslation = 'Translation';
    super.initState();
  }

  @override
  void dispose() {
    _catchwordCtrl.clear();
    _translationCtrl.clear();
    _clueCtrl.clear();
    super.dispose();
  }

  Word _createModel() {
    Word item = Word(
      categoryId: _selectedCategory.id,
      clue: _clueCtrl.value.text,
      catchword: _catchwordCtrl.value.text,
      userTranslation: _translationCtrl.value.text,
      id: DateTime.now().millisecondsSinceEpoch,
      isSentence: widget.isSentence ? 1 : 0,
      userLearning: userTranslation,
      userNative: catchword,
      isFavorite: _isFavorite == true ? 1 : 0,
      userId: -1,
    );
    return item;
  }

  @override
  Widget build(BuildContext context) {
    final bool isLong = widget.isSentence;
    const String cat = 'Category';
    const String clue = 'Clue';
    const String fav = 'Favorite';
    const String cancel = 'Cancel';
    const String submit = 'OK';
    return Form(
      key: _addNewWordModalFormKey,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        _buildFormField(catchword, isLong ? 50 : 25, _catchwordCtrl),
        _buildFormField(userTranslation, isLong ? 50 : 25, _translationCtrl),
        _buildFormField(clue, 50, _clueCtrl),
        _buildSelectCategory(cat, context),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(children: [
              Text(fav),
              Checkbox(
                activeColor: Colors.green.shade400,
                value: _isFavorite,
                onChanged: (bool? value) {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                },
              ),
            ]),
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(cancel, style: TextStyle(color: Colors.red, fontSize: 12.0))),
            OutlinedButton(
                onPressed: () => _submitForm(context),
                style: _btnStyle(),
                child: const Text(submit)),
          ],
        ),
      ]),
    );
  }

  ButtonStyle? _btnStyle({bool isCancel = false}) => ButtonStyle(
      shape: MaterialStateProperty.all<OutlinedBorder>(
          const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25.0)))),
      elevation: MaterialStateProperty.all<double>(2.2),
      shadowColor: MaterialStateProperty.all<Color>(Colors.green.shade50));

  void _submitForm(BuildContext context) {
    widget.handleErrorMessage('The last word was not saved. Sorry! Try to restart.');
    if (_addNewWordModalFormKey.currentState == null) {
      widget.handleErrorMessage('The last word was not saved. Sorry! Try to restart.');
      return Navigator.of(context).pop();
    }
    if (!_addNewWordModalFormKey.currentState!.validate()) {
      widget.handleErrorMessage('The last word was not saved. Sorry! Do you filled all fields?');
      return;
    }
    widget.handleSubmit(_createModel());
    Navigator.of(context).pop();
  }

  Padding _buildFormField(String label, int? maxCharacters, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
      child: TextFormField(
        controller: ctrl,
        maxLines: 1,
        maxLength: maxCharacters,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide(color: Color(0xff0E9447), width: 2.0),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide(color: Color(0xff0E9447), width: 2.0),
          ),
          // isCollapsed: true,
          floatingLabelStyle: const TextStyle(
            color: Colors.green,
          ),
          labelText: label,
          labelStyle: const TextStyle(fontSize: 12),
        ),
        validator: (String? v) => _formFieldValidation(v, label.toLowerCase()),
      ),
    );
  }

  String? _formFieldValidation(String? input, String label) {
    if (label == 'clue') return null;
    return (input == null || input.isEmpty) ? 'This field cannot be empty!' : null;
  }

  // if category name is longer then 15 characters - need to be trimmed!
  // WordCategory.name is max. 20 characters!
  Widget _buildSelectCategory(String hint, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20),
      child: DropDownSelect<WordCategory>(
        key: const Key('DropDownSelect-Category'),
        hintText: hint,
        options: widget.categories,
        // options: context.read<CategoriesProvider>().categories,
        value: _selectedCategory,
        onChanged: (WordCategory? newValue) {
          setState(() {
            _selectedCategory = newValue!;
          });
        },
        getLabel: (WordCategory value) => value.name,
      ),
    );
  }
}
