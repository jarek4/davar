import 'package:davar/src/authentication/authentication.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class AddNewWordModal extends StatefulWidget {
  const AddNewWordModal({
    Key? key,
    this.isSentence = false,
    this.themeColor = const Color(0XFFFF6D00), // DavarColors.wordColors2[1]
    required this.categories,
    required this.handleSubmit,
  }) : super(key: key);
  final Color themeColor;
  final bool isSentence;
  final List<WordCategory> categories;
  final Function handleSubmit;

  @override
  _AddNewWordModalState createState() => _AddNewWordModalState();
}

class _AddNewWordModalState extends State<AddNewWordModal> {
  final TextEditingController _catchwordCtrl = TextEditingController();
  final TextEditingController _translationCtrl = TextEditingController();
  final TextEditingController _clueCtrl = TextEditingController();
  final GlobalKey<FormState> _addNewWordModalFormKey = GlobalKey<FormState>();
  bool _isFavorite = false;
  String userNativeLanguage = 'other';
  String userLearningLanguage = 'other';
  String _errorInfo = '';
  late WordCategory _selectedCategory;

  @override
  void initState() {
    _isFavorite = false;
    _errorInfo = '';
    _selectedCategory = widget.categories[0];
    userNativeLanguage = context.read<AuthProvider>().user.native;
    userLearningLanguage = context.read<AuthProvider>().user.learning;
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
      userLearning: userLearningLanguage,
      userNative: userNativeLanguage,
      isFavorite: _isFavorite == true ? 1 : 0,
      userId: -1,
    );
    return item;
  }

  @override
  Widget build(BuildContext context) {
    final bool isSentence = widget.isSentence;
    final String cat = utils.capitalize(AppLocalizations.of(context)?.category ?? 'Category');
    final String clue = utils.capitalize(AppLocalizations.of(context)?.clue ?? 'Clue');
    final String fav = AppLocalizations.of(context)?.favorite ?? 'Favorite';
    final String cancel = utils.capitalize(AppLocalizations.of(context)?.cancel ?? 'Cancel');
    const String submit = 'OK';
    return Form(
      key: _addNewWordModalFormKey,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        _errorInfo.isNotEmpty ? SmallUserDialog(_errorInfo, _resetError) : const SizedBox.shrink(),
        _buildFormField(userNativeLanguage, isSentence ? 50 : 25, _catchwordCtrl),
        _buildFormField(userLearningLanguage, isSentence ? 50 : 25, _translationCtrl),
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
                child: Text(cancel, style: const TextStyle(color: Colors.red, fontSize: 12.0))),
            OutlinedButton(
                onPressed: () => _submitForm(context),
                style: _btnStyle(),
                child: const Text(submit)),
          ],
        ),
      ]),
    );
  }

  void _resetError() {
    setState(() {
      _errorInfo = '';
    });
  }

  ButtonStyle? _btnStyle() => ButtonStyle(
      shape: MaterialStateProperty.all<OutlinedBorder>(
          const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25.0)))),
      elevation: MaterialStateProperty.all<double>(2.2),
      shadowColor: MaterialStateProperty.all<Color>(Colors.green.shade50));

  void _submitForm(BuildContext context) {
    // final String fillAll = '${AppLocalizations.of(context)?.doFillFields}?';
    if (_addNewWordModalFormKey.currentState == null) {
      final String again = AppLocalizations.of(context)?.tryAgain ?? 'Try to restart';
      final String notSaved = AppLocalizations.of(context)?.notSaved ?? 'not saved';
      setState(() {
        _errorInfo = '$notSaved. $again';
      });
    }
    if (!_addNewWordModalFormKey.currentState!.validate()) {
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
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide(color: widget.themeColor, width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide(color: widget.themeColor, width: 2.0),
          ),
          // isCollapsed: true,
          floatingLabelStyle: TextStyle(
            color: widget.themeColor,
          ),
          labelText: label,
          labelStyle: const TextStyle(fontSize: 12),
        ),
        validator: (String? v) => _formFieldValidation(v, label.toLowerCase()),
      ),
    );
  }

  String? _formFieldValidation(String? input, String label) {
    final String c = AppLocalizations.of(context)?.clue ?? 'Clue';
    final String noEmpty = AppLocalizations.of(context)?.fieldNotEmpty ?? 'cannot be empty!';
    final String l = label.toLowerCase();
    if (l == 'clue' || l == c.toLowerCase()) return null;
    return (input == null || input.isEmpty) ? noEmpty : null;
  }

  // if category name is longer then 15 characters - need to be trimmed!
  // WordCategory.name is max. 20 characters!
  Widget _buildSelectCategory(String hint, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20),
      child: DropDownSelect<WordCategory>(
        key: const Key('AddNewWordModal-DropDownSelect-Category'),
        hintText: hint,
        options: widget.categories,
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
