import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String? email;
  final String? name;
  final String? imgUrl;
  final bool emailVerified;

  const UserModel({
    required this.uid,
    this.email,
    this.name,
    this.imgUrl,
    required this.emailVerified,
    // required this.provider,
  });

  factory UserModel.fromFirebaseUser(User user) => UserModel(
    uid: user.uid,
    email: user.email,
    name: user.displayName,
    imgUrl: user.photoURL,
    emailVerified: user.emailVerified,
    // provider: _mapProvider(user),
  );
}
