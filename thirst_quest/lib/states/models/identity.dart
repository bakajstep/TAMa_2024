class Identity {
  String id;
  String email;
  String username;
  bool googleAuth;
  List<String> roles;

  Identity({
    required this.id,
    required this.email,
    required this.username,
    required this.googleAuth,
    List<String>? roles,
  }) : roles = roles ?? <String>[];
}
