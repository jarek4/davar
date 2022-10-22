// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_WordCategory _$$_WordCategoryFromJson(Map<String, dynamic> json) =>
    _$_WordCategory(
      id: json['id'] as int,
      userId: json['userId'] as int,
      name: json['name'] as String? ?? 'no category',
    );

Map<String, dynamic> _$$_WordCategoryToJson(_$_WordCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
    };
