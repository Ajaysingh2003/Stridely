import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthDataSourceContract {
  Stream<User?> authStateChanges();

  Future<User?> currentUser();

  Future<User> signInWithEmail({
    required String email,
    required String password,
  });

  Future<User> signUpWithEmail({
    required String email,
    required String password,
  });

  Future<User> signInWithGoogle();

  Future<User> signInWithApple();

  Future<void> signOut();

  Future<void> deleteAccount();

  Future<void> sendPasswordResetEmail({required String email});

  Future<void> sendEmailVerification();

  Future<void> reloadUser();
}