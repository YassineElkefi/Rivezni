
class User {
  final String id;
  final String email;
  final String username;

  const User({
    required this.id,
    required this.email,
    required this.username,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
    };
  }

  static User fromJson(Map<String, dynamic> map) {
    return User(
      id: map["id"],
      email: map['email'] ?? '',
      username: map['username'] ?? '',
    );
  }
}