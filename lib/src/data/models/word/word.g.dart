// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Word _$$_WordFromJson(Map<String, dynamic> json) => _$_Word(
      category: json['category'] as String?,
      catchword: json['catchword'] as String,
      clue: json['clue'] as String?,
      createdAt: json['createdAt'] as String?,
      id: json['id'] as int,
      isFavorite: json['isFavorite'] as int? ?? 0,
      isSentence: json['isSentence'] as int? ?? 0,
      points: json['points'] as int? ?? 0,
      userId: json['userId'] as String,
      userLearning: json['userLearning'] as String? ?? 'Turkish',
      userNative: json['userNative'] as String? ?? 'English',
      userTranslation: json['userTranslation'] as String,
    );

Map<String, dynamic> _$$_WordToJson(_$_Word instance) => <String, dynamic>{
      'category': instance.category,
      'catchword': instance.catchword,
      'clue': instance.clue,
      'createdAt': instance.createdAt,
      'id': instance.id,
      'isFavorite': instance.isFavorite,
      'isSentence': instance.isSentence,
      'points': instance.points,
      'userId': instance.userId,
      'userLearning': instance.userLearning,
      'userNative': instance.userNative,
      'userTranslation': instance.userTranslation,
    };
