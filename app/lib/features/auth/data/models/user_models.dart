import 'package:app/features/auth/domain/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import '../../domain/entities/user_entity.dart';

class UserModel   {

  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final bool emailVerified;
  final AuthProviderType provider;

  const UserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    required this.emailVerified,
    required this.provider,
  });

  factory UserModel.fromFirebaseUser(User user) => UserModel(
    uid: user.uid,
    email: user.email,
    displayName: user.displayName,
    photoUrl: user.photoURL,
    emailVerified: user.emailVerified,
    provider: _mapProvider(user),

  );

  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      emailVerified: emailVerified,
      provider: provider,
    );
  }

  static AuthProviderType _mapProvider(User user) {
  if (user.isAnonymous) {
    return AuthProviderType.anonymous;
  }

  final providers = user.providerData;

  if (providers.any((p) => p.providerId == 'google.com')) {
    return AuthProviderType.google;
  }

  if (providers.any((p) => p.providerId == 'apple.com')) {
    return AuthProviderType.apple;
  }

  if (providers.any((p) => p.providerId == 'password')) {
    return AuthProviderType.email;
  }

  throw UnsupportedError(
    'Unsupported authentication provider: ${providers.map((e) => e.providerId).join(", ")}',
  );
}
}
