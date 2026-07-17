import 'package:equatable/equatable.dart';

enum AuthProviderType { email, google, apple, anonymous }

class UserEntity extends Equatable {
  final String uid;
  final String? email;
  final String? name;
  final String? imgUrl;
  final bool emailVerified;
  final bool isPremium;
  
  const UserEntity({
    required this.uid,
    this.email,
    this.name,
    this.imgUrl,
    required this.emailVerified,
    this.isPremium = false,
  });

  @override
  List<Object?> get props => [
    uid,
    email,
    name,
    imgUrl,
    emailVerified,
    isPremium,
    // isAnonymous,
    // provider,
  ];
}
