import 'package:freezed_annotation/freezed_annotation.dart';


part 'word.freezed.dart';
part 'word.g.dart';

@freezed
class Word with _$Word {
  const factory Word({
    required String catchword,
    required  int id,
    required int userId,
    required String userTranslation,
    @Default('') String category,
    @Default(1) int categoryId,
    @Default(0) int isFavorite,
    @Default(0) int isSentence,
    @Default(0) int points,
    @Default('Turkish') String userLearning, // ?
    @Default('English') String userNative,
    String? clue,
    String? createdAt,// ?
    }) = _Word;

  factory Word.fromJson(Map<String, dynamic> json) =>
      _$WordFromJson(json);
}