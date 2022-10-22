import 'package:davar/src/authentication/auth_provider.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/providers/providers.dart';
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddNewWordModal extends StatefulWidget {
  const AddNewWordModal({Key? key, this.isSentence = false}) : super(key: key);

  final bool isSentence;

  @override
  _AddNewWordModalState createState() => _AddNewWordModalState();
}

class _AddNewWordModalState extends State<AddNewWordModal> {
  final TextEditingController _catchwordCtrl = TextEditingController();
  final TextEditingController _translationCtrl = TextEditingController();
  final TextEditingController _categoryCtrl = TextEditingController();
  final TextEditingController _clueCtrl = TextEditingController();
  final GlobalKey<FormState> _addNewWordModalFormKey = GlobalKey<FormState>();
  bool _isFavorite = false;
  String catchword = 'English - demo';
  String userTranslation = 'Polish - demo';

  Word _handleSubmit() {
    Word item = Word(
      categoryId: /*_categoryCtrl.value.text*/ 1,
      clue: _clueCtrl.value.text,
      catchword: _catchwordCtrl.value.text,
      userTranslation: _translationCtrl.value.text,
      id: DateTime.now().millisecondsSinceEpoch,
      isSentence: widget.isSentence ? 1 : 0,
      userLearning: userTranslation,
      userNative: catchword,
      isFavorite: _isFavorite == true ? 1 : 0,
      userId: -1,
    ); // temporary
    Navigator.of(context).pop();
    return item;
  }

  @override
  void initState() {
    _isFavorite = false;
    String? _nativeFromState = 'nativeLang';
    String? _toLearnFromState = 'langToLearn';
    catchword = widget.isSentence ? 'Sentence' : 'Word';
    userTranslation = 'Translation';
    super.initState();
  }

  @override
  void dispose() {
    _catchwordCtrl.clear();
    _translationCtrl.clear();
    _categoryCtrl.clear();
    _clueCtrl.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLong = widget.isSentence;
    final String _cat = 'Category';
    final String _clue = 'Clue';
    final String _fav = 'Favorite';
    final String _cancel = 'Cancel';
    final String _submit = 'Submit';
    final bool _isAuthenticated = true;
    return Form(
      key: _addNewWordModalFormKey,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        _buildFormField(catchword, isLong ? 50 : 25, _catchwordCtrl),
        _buildFormField(userTranslation, isLong ? 50 : 25, _translationCtrl),
        // _buildFormField(_cat, null, _categoryCtrl),
        _buildFormField(_clue, 50, _clueCtrl),
        _buildSelectCategory(context),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(children: [
              Text(_fav),
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
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(_cancel)),
            TextButton(
                onPressed: () {
                  if (_isAuthenticated) {
                    // context.read<WordsCubit>().addNewWord(_handleSubmit());
                  } else {
                    //  context.read<DemoCubit>().addNewWord(_handleSubmit());
                  }
                },
                child: Text(_submit)),
          ],
        ),
      ]),
    );
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
          )),
    );
  }

  Widget _buildSelectCategory(BuildContext context) {
    return ChangeNotifierProvider<CategoriesProvider>(
            create: (_) => CategoriesProvider(context.read<AuthProvider>().user),
            child: Consumer<CategoriesProvider>(builder: (BuildContext context, CategoriesProvider provider, _) {              switch(provider.status) {
                case CategoriesProviderStatus.success:
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20),
                    child: DropDownSelect<String>(
                      key: const Key('DropDownSelect-Category'),
                      hintText: context.read<CategoriesProvider>().categoriesNames[0],
                      options: context.read<CategoriesProvider>().categoriesNames,
                      value: context.read<CategoriesProvider>().categoriesNames[0],
                      onChanged: (String? newValue) {},
                      getLabel: (String value) => value,
                    ),
                  );
              case CategoriesProviderStatus.loading:
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 20),
                  child: SizedBox(height: 5, child: LinearProgressIndicator(),),
                );
                default:
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 20),
                    child: Text('It was not able to load categories 🥴'),
                  );
              }

              }
            ),

        );


  }
}

/*
Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20),
                    child: DropDownSelect<String>(
                      key: const Key('DropDownSelect-Category'),
                      hintText: 'Please select',
                      options: const ['no-category'],
                      value: 'no-category',
                      onChanged: (String? newValue) {},
                      getLabel: (String value) => value,
                    ),
                  );

Widget _buildSelectCategory(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 35),
        child: DropDownSelect<WordCategory>(
          key: const Key('DropDownSelect-Category'),
          hintText: 'Category',
          options: context.read<CategoriesProvider>().categories,
          value: context.read<CategoriesProvider>().categories[0],
          onChanged: (WordCategory? newValue) {},
          getLabel: (WordCategory value) => value.name,
        ),
      );

  }
 */