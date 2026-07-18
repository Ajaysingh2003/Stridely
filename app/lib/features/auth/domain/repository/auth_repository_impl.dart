import 'package:app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:app/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../../domain/entities/auth_failure.dart';
import '../../domain/entities/user_entity.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _datasource;

  AuthRepositoryImpl(this._datasource);

  UserEntity? _mapFirebaseUser(User? user) {
    if (user == null) return null;

    return UserEntity(
      uid: user.uid,
      email: user.email,
      name: user.displayName,
      imgUrl: user.photoURL,
      emailVerified: user.emailVerified,
    );
  }

  UserEntity? _mapUserData(Map<String, dynamic>? userData) {
    if (userData == null) return null;

    final uid = userData['uid'];
    if (uid is! String || uid.isEmpty) return null;

    return UserEntity(
      uid: uid,
      email: userData['email'] as String?,
      name: userData['name'] as String?,
      imgUrl: (userData['imgUrl'] ?? userData['ImgUrl']) as String?,
      emailVerified:
          (userData['emailVerified'] ?? userData['isVerified']) as bool? ??
          false,
      isPremium: userData['isPremium'] as bool? ?? false,
    );
  }

  @override
  Stream<UserEntity?> get authStateChanges =>
      _datasource.authStateChanges().map(_mapUserData);

  @override
  Future<UserEntity?> getCurrentUser() async {
    final userData = await _datasource.currentUser();
    return _mapUserData(userData);
  }

 @override
Future<Either<AuthFailure, UserEntity>> signInWithEmail({
  required String email,
  required String password,
}) async {
  try {
    // 1. Await the tuple record from your datasource
    final (rawUser, failure) = await _datasource.signInWithEmail(
      email: email,
      password: password,
    );

    // 2. Check if the datasource returned an operational failure first
    if (failure != null) {
      return Left(failure);
    }

    // 3. If rawUser is null, convert it to a ServerFailure, else map it to UserEntity
    if (rawUser == null) {
      return const Left(ServerFailure('User data missing after successful auth.'));
    }

    // 4. Map the valid Firebase User to your clean domain UserEntity
    final userEntity = _mapFirebaseUser(rawUser);

    if (userEntity == null) {
  return const Left(ServerFailure('Failed to parse user profile data.'));
}
    return Right(userEntity);

  } on FirebaseAuthException catch (e) {
    return Left(_mapFirebaseError(e));
  } catch (_) {
    return const Left(ServerFailure());
  }
}

  @override
  Future<Either<AuthFailure, UserEntity>> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final rawUser = await _datasource.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );
      return _successOrMappingFailure(_mapFirebaseUser(rawUser));
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseError(e));
    } catch (_) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<AuthFailure, UserEntity>> signInWithGoogle() async {
    try {
      final rawUser = await _datasource.signInWithGoogle();
      return _successOrMappingFailure(_mapFirebaseUser(rawUser));
    } on CancelledByUserFailure catch (e) {
      return Left(e);
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseError(e));
    } on PlatformException catch (e) {
      if (e.code == 'sign_in_canceled' || e.code == 'sign_in_failed') {
        return const Left(CancelledByUserFailure());
      }
      return Left(
        ServerFailure(e.message ?? 'Platform error during Google Sign-In.'),
      );
    } catch (_) {
      // print('Unexpected error during Google Sign-In: $e');
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<AuthFailure, UserEntity>> signInWithApple() async {
    try {
      final rawUser = await _datasource.signInWithApple();
      return _successOrMappingFailure(_mapFirebaseUser(rawUser));
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseError(e));
    } catch (e) {
      final message = e.toString().toLowerCase();
      if (message.contains('canceled') || message.contains('cancelled')) {
        return const Left(CancelledByUserFailure());
      }
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> reloadUser() async {
    try {
      await _datasource.reloadUser();
      return const Right(unit);
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseError(e));
    } catch (_) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await _datasource.sendPasswordResetEmail(email: email.trim());
      return const Right(unit);
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseError(e));
    } catch (_) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<void> signOut() => _datasource.signOut();

  Either<AuthFailure, UserEntity> _successOrMappingFailure(UserEntity? user) {
    if (user == null) {
      return const Left(ServerFailure('User mapping failed.'));
    }
    return Right(user);
  }

  AuthFailure _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return const InvalidEmailFailure();
      case 'wrong-password':
      case 'invalid-credential':
        return const WrongPasswordFailure();
      case 'user-not-found':
        return const UserNotFoundFailure();
      case 'email-already-in-use':
        return const EmailAlreadyInUseFailure();
      case 'weak-password':
        return const WeakPasswordFailure();
      case 'account-exists-with-different-credential':
        return const AccountExistsWithDifferentCredentialFailure();
      case 'sign-in-cancelled':
      case 'ERROR_ABORTED_BY_USER':
        return const CancelledByUserFailure();
      default:
        return ServerFailure(e.message ?? 'Something went wrong.');
    }
  }
}
