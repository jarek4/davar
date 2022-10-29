import 'package:freezed_annotation/freezed_annotation.dart';


part 'word_category.freezed.dart';
part 'word_category.g.dart';

@freezed
class WordCategory  with _$WordCategory {
  const factory WordCategory({
    required  int id,
    required int userId,
    @Default('no category') String name,// ? not longer then 20 characters!

  }) = _WordCategory;

  factory WordCategory.fromJson(Map<String, dynamic> json) =>
      _$WordCategoryFromJson(json);
}