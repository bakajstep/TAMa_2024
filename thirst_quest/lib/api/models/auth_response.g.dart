// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse(
      token: json['token'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      role: (json['role'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) => <String, dynamic>{
      'token': instance.token,
      'role': instance.role,
      'user': instance.user,
    };
