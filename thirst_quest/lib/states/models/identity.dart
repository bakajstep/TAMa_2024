class Identity {
  String id;
  String email;
  String username;
  List<String> roles;

  Identity({
    required this.id,
    required this.email,
    required this.username,
    List<String>? roles,
  }) : roles = roles ?? <String>[];
}
