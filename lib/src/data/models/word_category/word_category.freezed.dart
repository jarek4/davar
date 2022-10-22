// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'word_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

WordCategory _$WordCategoryFromJson(Map<String, dynamic> json) {
  return _WordCategory.fromJson(json);
}

/// @nodoc
mixin _$WordCategory {
  int get id => throw _privateConstructorUsedError;
  int get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WordCategoryCopyWith<WordCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WordCategoryCopyWith<$Res> {
  factory $WordCategoryCopyWith(
          WordCategory value, $Res Function(WordCategory) then) =
      _$WordCategoryCopyWithImpl<$Res>;
  $Res call({int id, int userId, String name});
}

/// @nodoc
class _$WordCategoryCopyWithImpl<$Res> implements $WordCategoryCopyWith<$Res> {
  _$WordCategoryCopyWithImpl(this._value, this._then);

  final WordCategory _value;
  // ignore: unused_field
  final $Res Function(WordCategory) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? name = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: userId == freezed
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_WordCategoryCopyWith<$Res>
    implements $WordCategoryCopyWith<$Res> {
  factory _$$_WordCategoryCopyWith(
          _$_WordCategory value, $Res Function(_$_WordCategory) then) =
      __$$_WordCategoryCopyWithImpl<$Res>;
  @override
  $Res call({int id, int userId, String name});
}

/// @nodoc
class __$$_WordCategoryCopyWithImpl<$Res>
    extends _$WordCategoryCopyWithImpl<$Res>
    implements _$$_WordCategoryCopyWith<$Res> {
  __$$_WordCategoryCopyWithImpl(
      _$_WordCategory _value, $Res Function(_$_WordCategory) _then)
      : super(_value, (v) => _then(v as _$_WordCategory));

  @override
  _$_WordCategory get _value => super._value as _$_WordCategory;

  @override
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? name = freezed,
  }) {
    return _then(_$_WordCategory(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: userId == freezed
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_WordCategory implements _WordCategory {
  const _$_WordCategory(
      {required this.id, required this.userId, this.name = 'no category'});

  factory _$_WordCategory.fromJson(Map<String, dynamic> json) =>
      _$$_WordCategoryFromJson(json);

  @override
  final int id;
  @override
  final int userId;
  @override
  @JsonKey()
  final String name;

  @override
  String toString() {
    return 'WordCategory(id: $id, userId: $userId, name: $name)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_WordCategory &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.userId, userId) &&
            const DeepCollectionEquality().equals(other.name, name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(userId),
      const DeepCollectionEquality().hash(name));

  @JsonKey(ignore: true)
  @override
  _$$_WordCategoryCopyWith<_$_WordCategory> get copyWith =>
      __$$_WordCategoryCopyWithImpl<_$_WordCategory>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_WordCategoryToJson(
      this,
    );
  }
}

abstract class _WordCategory implements WordCategory {
  const factory _WordCategory(
      {required final int id,
      required final int userId,
      final String name}) = _$_WordCategory;

  factory _WordCategory.fromJson(Map<String, dynamic> json) =
      _$_WordCategory.fromJson;

  @override
  int get id;
  @override
  int get userId;
  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$_WordCategoryCopyWith<_$_WordCategory> get copyWith =>
      throw _privateConstructorUsedError;
}
