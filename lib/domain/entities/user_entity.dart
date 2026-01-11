class UserEntity {
  final String uid;
  final String email;
  final DateTime createdAt;

  UserEntity({required this.uid, required this.email, required this.createdAt});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserEntity &&
        other.uid == uid &&
        other.email == email &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode => uid.hashCode ^ email.hashCode ^ createdAt.hashCode;
}
