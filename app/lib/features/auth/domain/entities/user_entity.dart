import 'package:equatable/equatable.dart';

enum AuthProviderType {
  email,
  google,
  apple,
  anonymous,
}

class UserEntity extends Equatable {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final bool emailVerified;
  // final bool isAnonymous;
  final AuthProviderType provider;

  const UserEntity({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    required this.emailVerified,
    // required this.isAnonymous,
    required this.provider,
  });

  @override
  List<Object?> get props => [
        uid,
        email,
        displayName,
        photoUrl,
        emailVerified,
        // isAnonymous,
        provider,
      ];
}