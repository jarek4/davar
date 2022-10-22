// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$$_UserFromJson(Map<String, dynamic> json) => _$_User(
      createdAt: json['createdAt'] as String? ?? '0000.00.00',
      email: json['email'] as String? ?? 'empty',
      id: json['id'] as int? ?? 1,
      learning: json['learning'] as String? ?? 'empty',
      name: json['name'] as String? ?? 'empty',
      native: json['native'] as String? ?? 'empty',
      password: json['password'] as String? ?? '',
      authToken: json['authToken'] as String?,
    );

Map<String, dynamic> _$$_UserToJson(_$_User instance) => <String, dynamic>{
      'createdAt': instance.createdAt,
      'email': instance.email,
      'id': instance.id,
      'learning': instance.learning,
      'name': instance.name,
      'native': instance.native,
      'password': instance.password,
      'authToken': instance.authToken,
    };
