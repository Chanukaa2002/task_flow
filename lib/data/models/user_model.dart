import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_flow/domain/entities/user_entity.dart';

class UserModel {
  final String uid;
  final String email;
  final DateTime createdAt;

  UserModel({required this.uid, required this.email, required this.createdAt});


  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      createdAt: user.metadata.creationTime ?? DateTime.now(),
    );
  }

  UserEntity toEntity() {
    return UserEntity(uid: uid, email: email, createdAt: createdAt);
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
