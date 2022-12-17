import 'package:davar/locator.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/domain/i_words_repository.dart';
import 'package:flutter/cupertino.dart';

enum EditWordProviderStatus { error, loading, success }

/// receives the Word item to edition. Sets received item to edited item
/// Then view returns edited item through Navigator.pop
class EditWordProvider with ChangeNotifier {
  EditWordProvider(this._passedToEdit) {
    _edited = _passedToEdit;
  }

  final Word _passedToEdit;

  final IWordsRepository<Word> _wordsRepository = locator<IWordsRepository<Word>>();

  static const String _notSaved = 'The last change is not saved!';
  static const String _errorInfo =
      'The word/sentence was not updated. Error! Try to restart application';

  late Word _edited;

  Word get edited => _edited;

  String _editWordProviderError = '';

  String get editWordProviderError => _editWordProviderError;

  bool get hasChanged => _passedToEdit != _edited;

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

  void onEditCategory(WordCategory newCategory) {
    _edited = _edited.copyWith(categoryId: newCategory.id, category: newCategory.name);
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
    if (_edited == _passedToEdit) return _passedToEdit;
    _status = EditWordProviderStatus.loading;
    notifyListeners();
    try {
      final int res = await _wordsRepository.update(_edited);
      if (res < 1) {
        _editWordProviderError = _notSaved;
        _edited = _passedToEdit;
      }
      _status = EditWordProviderStatus.success;
      notifyListeners();
      return _edited;
    } catch (e) {
      _editWordProviderError = _errorInfo;
      _status = EditWordProviderStatus.error;
      _edited = _passedToEdit;
      notifyListeners();
      return _edited;
    }
  }
}
