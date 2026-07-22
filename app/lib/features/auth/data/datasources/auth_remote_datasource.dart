import 'package:app/features/auth/data/datasources/contract_datasource.dart';
import 'package:app/features/auth/domain/entities/auth_failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'auth_data_source_contract.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRemoteDatasource implements AuthDataSourceContract {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  Future<void>? _googleSignInInitializeFuture;
  AuthRemoteDatasource(this._firebaseAuth, this._firestore);

  Future<void> _initializeGoogleSignIn() {
    return _googleSignInInitializeFuture ??= _googleSignIn.initialize();
  }

  @override
  Stream<Map<String, dynamic>?> authStateChanges() {
    return _firebaseAuth.authStateChanges().asyncExpand((firebaseUser) {
      if (firebaseUser == null) {
        return Stream.value(null);
      }

      return _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .snapshots()
          .map((doc) {
            final data = doc.data() ?? {};

            return {
              'uid': firebaseUser.uid,
              'email': data['email'] ?? firebaseUser.email,
              'name': data['name'] ?? firebaseUser.displayName,
              'imgUrl': data['imgUrl'] ?? firebaseUser.photoURL,
              'emailVerified': firebaseUser.emailVerified,
              "points":data["points"],
              ...data,
            };
          });
    });
  }

  @override
  Future<Map<String, dynamic>?> currentUser() async {
    await _firebaseAuth.idTokenChanges().first;

    final userId = _firebaseAuth.currentUser?.uid;

    final docSnapshot = await _firestore.collection("users").doc(userId).get();

    if (!docSnapshot.exists) return null;

    final data = docSnapshot.data();

    return data;
  }

 @override
Future<(User?, AuthFailure?)> signInWithEmail({
  required String email,
  required String password,
}) async {
  try {
    final cred = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (cred.user != null) {
      return (cred.user, null); // Success: Return user, no failure
    } else {
      
      return (null, const ServerFailure('User data missing after auth.'));
    }
  } on FirebaseAuthException catch (e) {

    
    
    
    
    // Map Firebase errors directly to your custom AuthFailure classes
    final failure = switch (e.code) {
      'invalid-credential' => const UserNotFoundFailure(),
      'wrong-password' => const WrongPasswordFailure(),
      'invalid-email' => const InvalidEmailFailure(),
      _ => ServerFailure(e.message ?? 'Authentication failed.'),
    };
    
    return (null, failure); // Return the concrete failure object
  } catch (e) {
    
    return (null, ServerFailure(e.toString()));
  }
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

    final userID = cred.user?.uid;
    _firestore.collection("users").doc(userID).set({
      'uid': userID,
      'email': email,
      'name': displayName,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'isPremium': false,
      "imgUrl": cred.user?.photoURL,
      "isActivate": true,
      "isVerified": cred.user?.emailVerified,
      "streak": {"current": 0, "longest": 0},
      // 'bookReads': [],
    });

    return cred.user!;
  }

  @override
  Future<User> signInWithGoogle() async {
    await _initializeGoogleSignIn();

    late final GoogleSignInAccount googleUser;
    try {
      googleUser = await _googleSignIn.authenticate();
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled ||
          e.code == GoogleSignInExceptionCode.interrupted) {
        throw FirebaseAuthException(
          code: 'sign-in-cancelled',
          message: 'Sign in was cancelled.',
        );
      }
      rethrow;
    }

    final GoogleSignInAuthentication googleAuth = googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    final UserCredential cred = await _firebaseAuth.signInWithCredential(
      credential,
    );

    final userID = cred.user?.uid;

    if (userID != null) {
      // 1. Fetch the document snapshot from your collection
      final userDoc = await _firestore.collection("users").doc(userID).get();

      // 2. Check the snapshot's structural existence property
      if (!userDoc.exists) {
        // 🚀 The user is signing up for the very first time! Initialize their records safely:
        await _firestore.collection("users").doc(userID).set({
          'uid': userID,
          'email': cred.user?.email,
          'name': cred.user?.displayName,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'isPremium': false,
          "imgUrl": cred.user?.photoURL,
          "isActivate": true,
          "isVerified": cred.user?.emailVerified,
          "streak": {"current": 0, "longest": 0},
        });
      } else {
        await _firestore.collection("users").doc(userID).update({
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    }
    return cred.user!;
  }

  // @override
  // Future<User> signInWithApple() async {
  //   throw UnimplementedError('Apple sign-in not implemented yet');
  // }

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
