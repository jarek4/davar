class Option {
  const Option({required this.text, required this.wordId, this.isCorrect = false, this.isSelected = false});

  final String text;
  final int wordId;
  final bool isCorrect;
  final bool isSelected;

  Option copyWith({String? text, int? wordId, bool? isCorrect, bool? isSelected}) {
    return Option(
        text: text ?? this.text,
        wordId: wordId ?? this.wordId,
        isCorrect: isCorrect ?? this.isCorrect,
        isSelected: isSelected ?? this.isSelected);
  }

  @override
  String toString() {
    return 'Option:\n isCorrect: $isCorrect,\n,text: $text,\n wordId: $wordId,\n isSelected: $isSelected;\n';
  }

  @override
  operator ==(other) =>
      other is Option &&
          other.text == text &&
          other.isCorrect == isCorrect &&
          other.wordId == wordId &&
          other.isSelected == isSelected;

  @override
  int get hashCode => Object.hashAll([text, isCorrect, isSelected, wordId]);
}