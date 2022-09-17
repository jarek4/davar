import 'package:freezed_annotation/freezed_annotation.dart';


part 'word.freezed.dart';
part 'word.g.dart';

@freezed
class Word with _$Word {
  const factory Word({
    String? category,
    required String catchword,
    String? clue,
    String? createdAt,
    required  int id,
    @Default(0) int isFavorite,
    @Default(0) int isSentence,
    @Default(0) int points,
    required String userId,
    @Default('Turkish') String userLearning, // ?
    @Default('English') String userNative, // ?
    required String userTranslation,
    }) = _Word;

  factory Word.fromJson(Map<String, dynamic> json) =>
      _$WordFromJson(json);
}