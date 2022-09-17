import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    @Default('0000.00.00') String createdAt,
    @Default('empty') String email,
    @Default(-1) int id,
    @Default('Turkish') String learning,
    @Default('empty') String name,
    @Default('English') String native,
    @Default('') String password,
    String? authToken,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);
}

// default or empty User returned when there is NO User:
// User(email: 'empty' , id: -1, name: 'empty', password: '', authToken: null);