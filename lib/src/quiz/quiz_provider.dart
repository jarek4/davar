import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/providers/providers.dart';
import 'package:flutter/foundation.dart';

import 'models/models.dart';

class QuizProvider with ChangeNotifier {
  QuizProvider(this.wordsProvider, this.inGameWords){
    state = QuizState(
      words: wordsProvider.words,
      currentUserWordsIds: wordsProvider.words.map((e) => e.id).toList(),
      inGameWords: inGameWords,
      guessingWordPoints: inGameWords.isEmpty ? -1 : inGameWords[0].points,
      notPlayedIds:
      wordsProvider.words.map((e) => e.id).where((element) => element != inGameWords[0].id).toList(),
      question: Question(inGameWords: inGameWords.isEmpty ? [] : inGameWords),
      options: _makeOptions(inGameWords.isEmpty ? [] : inGameWords),
      successId: inGameWords.isEmpty ? -1 : inGameWords[0].id,
    );
  }


  final WordsProvider wordsProvider;
  final List<Word> inGameWords;

  late QuizState state;

  static List<Option> _makeOptions(List<Word> inGameWords) {
    if(inGameWords.isEmpty) return <Option>[];
    List<Option> options = [];
    Word first = inGameWords[0];
    Option correct = Option(text: first.userTranslation, wordId: first.id, isCorrect: true);
    options.add(correct);
    List<Option> notCorrect = inGameWords.sublist(1).map((e) => Option(text: e.userTranslation, wordId: e.id)).toList();
    options.addAll(notCorrect);
    // options.shuffle();
    return options;
  }

}