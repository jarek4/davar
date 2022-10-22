// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Word _$$_WordFromJson(Map<String, dynamic> json) => _$_Word(
      catchword: json['catchword'] as String,
      id: json['id'] as int,
      userId: json['userId'] as int,
      userTranslation: json['userTranslation'] as String,
      category: json['category'] as String? ?? '',
      categoryId: json['categoryId'] as int? ?? 1,
      isFavorite: json['isFavorite'] as int? ?? 0,
      isSentence: json['isSentence'] as int? ?? 0,
      points: json['points'] as int? ?? 0,
      userLearning: json['userLearning'] as String? ?? 'Turkish',
      userNative: json['userNative'] as String? ?? 'English',
      clue: json['clue'] as String?,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$$_WordToJson(_$_Word instance) => <String, dynamic>{
      'catchword': instance.catchword,
      'id': instance.id,
      'userId': instance.userId,
      'userTranslation': instance.userTranslation,
      'category': instance.category,
      'categoryId': instance.categoryId,
      'isFavorite': instance.isFavorite,
      'isSentence': instance.isSentence,
      'points': instance.points,
      'userLearning': instance.userLearning,
      'userNative': instance.userNative,
      'clue': instance.clue,
      'createdAt': instance.createdAt,
    };
