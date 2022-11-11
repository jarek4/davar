import 'package:davar/locator.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/domain/i_words_repository.dart';
import 'package:flutter/cupertino.dart';

enum EditWordProviderStatus { error, loading, success }

/// receives the Word item to edition. Sets received item to edited item
/// Then view returns edited item through Navigator.pop
class EditWordProvider with ChangeNotifier {
  EditWordProvider(this._received) {
    _edited = _received;
  }

  final IWordsRepository<Word> _wordsRepository = locator<IWordsRepository<Word>>();

  static const String _notSaved = 'The last change is not saved!';
  static const String _errorInfo =
      'The word/sentence was not updated. Error! Try to restart application';

  final Word _received;

  Word get received => _received;

  late Word _edited;

  Word get edited => _edited;

  String _editWordProviderError = '';

  String get editWordProviderError => _editWordProviderError;

  bool get hasChanged => _received != _edited;
/*  int _deleteResponse = 0;
  int get deleteResponse => _deleteResponse;
  int _saveResponse = 0;
  int get saveResponse => _saveResponse;*/

  EditWordProviderStatus _status = EditWordProviderStatus.success;

  EditWordProviderStatus get status => _status;

  Future<void> reversIsFavorite() async {
    final int newFavValue = _edited.isFavorite == 0 ? 1 : 0;
    _edited = _edited.copyWith(isFavorite: newFavValue);
    notifyListeners();
  }

  // in EditWordDialogWidget onPressed: () => widget.handle(_ctr.value.text)
  void onEditUserTranslation(String newUserTranslation) {
    _edited = _edited.copyWith(userTranslation: newUserTranslation);
    notifyListeners();
  }

  void onEditCatchword(String newCatchword) {
    _edited = _edited.copyWith(catchword: newCatchword);
    notifyListeners();
  }

  void onEditCategory(int newId) {
    _edited = _edited.copyWith(categoryId: newId);
    notifyListeners();
  }

  void onEditClue(String newClue) {
    _edited = _edited.copyWith(clue: newClue);
    notifyListeners();
  }

  void onResetPoints() {
    _edited = _edited.copyWith(points: 0);
    notifyListeners();
  }

  /// If changes are saved successfully returns 1, if no changes was made returns 0, on error returns -1.
  Future<Word> onSave() async {
    if (_edited == _received) return _received;
    _status = EditWordProviderStatus.loading;
    notifyListeners();
    try {
      final int res = await _wordsRepository.update(_edited);
      if (res < 1) {
        _editWordProviderError = _notSaved;
        _edited = _received;
      }
      _status = EditWordProviderStatus.success;
      notifyListeners();
      return _edited;
    } catch (e) {
      print('EditWordProvider onSave Error: $e');
      _editWordProviderError = _errorInfo;
      _status = EditWordProviderStatus.error; // or success?
      _edited = _received;
      notifyListeners();
      return _edited;
    }
  }

  // /// Returns 1 if was deleted from database, if not returns 0, on error returns -1.
  // Future<int> onDelete(int id) async {
  //   _status = EditWordProviderStatus.loading;
  //   notifyListeners();
  //   try {
  //     final int res = await _wordsRepository.delete(id);
  //     if (res < 1) {
  //       _editWordProviderError = 'The word was not deleted.';
  //     }
  //     _status = EditWordProviderStatus.success;
  //     notifyListeners();
  //     return res;
  //   } catch (e) {
  //     print('EditWordProvider onDelete(id=$id) Error: $e');
  //     _editWordProviderError = _errorInfo;
  //     _status = EditWordProviderStatus.error; // or success?
  //     notifyListeners();
  //     return -1;
  //   }
  // }
/*

  String _testText = 'Initial value';

  String get testText => _testText;

  void setTestText(String? v) {
    v ??= 'defaul valu';
    _testText = v;
    print('EditWordProvider setTestText($v)');
    notifyListeners();
  }

  void setTestText2() {
    _testText = 'setTestText2()';
    print('EditWordProvider setTestText2()');
    notifyListeners();
  }
*/

/*void setup() {
    _status = EditWordProviderStatus.loading;
    notifyListeners();
    _status = EditWordProviderStatus.loading;
    notifyListeners();
  }*/
}

/*
 Future<void> editCatchword(String newCatchword) async {
    final Word updated =  _edited.copyWith(catchword: newCatchword);
    try {
      final int? res =
          await _wordsRepository.rawUpdate([DbConsts.colWCatchword], [newCatchword], updated.id);
      if (res == null) _editWordProviderError = _notSaved;
      // _item = updated;
      _edited = updated;
      notifyListeners();
    } on Exception {
      _editWordProviderError = _errorInfo;
      notifyListeners();
    }
  }

  Future<void> editCategory(int newId) async {
    final Word updated =  _edited.copyWith(categoryId: newId);
    try {
      final int? res =
          await _wordsRepository.rawUpdate([DbConsts.colWCategoryId], [newId], updated.id);
      if (res == null) _editWordProviderError = _notSaved;
      // _item = updated;
      _edited = updated;
      notifyListeners();
    } on Exception {
      _editWordProviderError = _errorInfo;
      notifyListeners();
    }
  }

  Future<void> editClue(String newClue) async {
    final Word updated =  _edited.copyWith(clue: newClue);
    try {
      final int? res = await _wordsRepository.rawUpdate([DbConsts.colWClue], [newClue], updated.id);
      if (res == null) _editWordProviderError = _notSaved;
      // _item = updated;
      _edited = updated;
      notifyListeners();
    } on Exception {
      _editWordProviderError = _errorInfo;
      notifyListeners();
    }
  }

  Future<void> resetPoints() async {
    final Word updated =  _edited.copyWith(points: 0);
    try {
      final int? res = await _wordsRepository.rawUpdate([DbConsts.colWPoints], [0], updated.id);
      if (res == null) _editWordProviderError = _notSaved;
     // _item = updated;
      _edited = updated;
      notifyListeners();
    } on Exception {
      _editWordProviderError = _errorInfo;
      notifyListeners();
    }
  }

 */
