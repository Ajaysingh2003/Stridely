
import 'package:app/features/auth/domain/entities/auth_failure.dart';
import 'package:dartz/dartz.dart';

import 'package:app/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get authStateChanges;

  Future<UserEntity?> getCurrentUser();


  Future<Either<AuthFailure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Either<AuthFailure, UserEntity>> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  });

  Future<Either<AuthFailure, UserEntity>> signInWithGoogle();
  Future<Either<AuthFailure, UserEntity>> signInWithApple();

  Future<void> sendPasswordResetEmail({
    required String email,
  });
  Future<void> reloadUser();
  Future<void> signOut();

}