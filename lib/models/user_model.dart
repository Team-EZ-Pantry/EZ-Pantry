class User {
  final int? userId;
  final String username;
  final String email;
  final DateTime createdAt;

  User({
    required this.userId,
    required this.username,
    required this.email,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    
    final user = User(
      userId: json['user_id'] as int?,
      username: json['username'] as String,
      email: json['email'] as String, 
      createdAt: DateTime.parse(json['created_at'] as String? ?? DateTime.now().toIso8601String()),
    );
    
    return user;
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'email': email,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // For debugging
  @override
  String toString() {
    return 'User(userId: $userId, username: $username, email: $email)';
  }
}
