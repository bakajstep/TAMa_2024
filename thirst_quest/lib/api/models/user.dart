import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String email;
  final String username;
  final bool authByGoogle;
  final String? profilePicture;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.authByGoogle,
    required this.profilePicture,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
