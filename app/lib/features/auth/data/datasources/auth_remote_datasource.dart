import 'package:app/features/auth/data/datasources/contract_datasource.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'auth_data_source_contract.dart';

class AuthRemoteDatasource implements AuthDataSourceContract {
  final FirebaseAuth _firebaseAuth;

  AuthRemoteDatasource(this._firebaseAuth);

  @override
  Stream<User?> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }

  @override
  Future<User?> currentUser() async {
    return _firebaseAuth.currentUser;
  }

  @override
  Future<User> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final cred = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user!;
  }

  @override
  Future<User> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final cred = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (displayName != null && displayName.isNotEmpty) {
      await cred.user!.updateDisplayName(displayName);
      await cred.user!.reload();
    }
    return cred.user!;
  }

  @override
  Future<User> signInWithGoogle() async {
    throw UnimplementedError('Google sign-in not implemented yet');
  }

  @override
  Future<User> signInWithApple() async {
    throw UnimplementedError('Apple sign-in not implemented yet');
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> deleteAccount() async {
    await _firebaseAuth.currentUser?.delete();
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
  await _firebaseAuth.sendPasswordResetEmail(email: email);
}

  @override
  Future<void> sendEmailVerification() async {
    await _firebaseAuth.currentUser?.sendEmailVerification();
  }

  @override
  Future<void> reloadUser() async {
    await _firebaseAuth.currentUser?.reload();
  }
}