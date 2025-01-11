import 'package:json_annotation/json_annotation.dart';
import 'package:thirst_quest/api/models/user.dart';

part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse {
  final String token;
  final List<String> role;
  final User user;

  AuthResponse({
    required this.token,
    required this.user,
    List<String>? role,
  }) : role = role ?? <String>[];

  factory AuthResponse.fromJson(Map<String, dynamic> json) => _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}
