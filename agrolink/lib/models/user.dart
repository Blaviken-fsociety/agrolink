class User {
  final String name;
  final String email;
  final String password;
  final List<String> availability;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.availability,
  });
}