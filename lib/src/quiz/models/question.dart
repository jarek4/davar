import 'package:davar/src/data/models/models.dart';

class Question {
  const Question({required this.inGameWords});

  final List<Word> inGameWords; // [0, 1, 2] -> 0 is success!

  static const String errorInfo = 'No words added!';


  int successOptionId() {
    if(inGameWords.isEmpty) return -1;
    return inGameWords[0].id;
  }

  String text() {
    if(inGameWords.isEmpty) return errorInfo;
    return inGameWords[0].userTranslation;
  }

  String? clue() {
    if(inGameWords.isEmpty) return errorInfo;
    return inGameWords[0].clue;
  }

  @override
  String toString() {
    return 'Question: \n inGameWords: $inGameWords,\n';
  }

  @override
  operator ==(other) => other is Question && other.inGameWords == inGameWords;

  @override
  int get hashCode => Object.hashAll(inGameWords);
}