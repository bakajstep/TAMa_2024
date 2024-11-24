class Identity {
  String id;
  String email;
  String username;
  String? pictureUrl;
  bool googleAuth;
  List<String> roles;

  Identity({
    required this.id,
    required this.email,
    required this.username,
    required this.googleAuth,
    required this.pictureUrl,
    List<String>? roles,
  }) : roles = roles ?? <String>[];
}
