class Identity {
  final String id;
  final String email;
  final String username;
  final List<String> roles;

  Identity({
    required this.id,
    required this.email,
    required this.username,
    List<String>? roles,
  }) : roles = roles ?? <String>[];
}
