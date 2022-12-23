import 'package:davar/src/data/models/models.dart';

class Question {
  const Question({required this.inGameWords});

  final List<Word> inGameWords; // [0, 1, 2] -> 0 is success!

  static const String errorInfo = 'No words added!';

  int successOptionId() {
    if (inGameWords.isEmpty) return -1;
    return inGameWords[0].id;
  }

  // if Question.text() => inGameWords[0].catchword
  // options should be inGameWords[i].userTranslation
  String text() {
    if (inGameWords.isEmpty) return errorInfo;
    return inGameWords[0].catchword;
  }

  String? clue() {
    if (inGameWords.isEmpty) return errorInfo;
    return inGameWords[0].clue;
  }

  @override
  String toString() {
    return 'Question: \n inGameWords: $inGameWords,\n';
  }

  @override
  bool operator ==(Object other) {
    if (other is Question) {
      if (inGameWords.length != other.inGameWords.length) return false;
      for (int i = 0; i < inGameWords.length; i++) {
        if (inGameWords[i] != other.inGameWords[i]) return false;
      }
      return true;
    }
    return false;
  }

  @override
  int get hashCode => Object.hashAll(inGameWords);
}
