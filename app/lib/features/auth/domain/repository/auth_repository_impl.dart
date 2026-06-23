import 'package:app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:app/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/auth_failure.dart';
import '../../domain/entities/user_entity.dart';


AuthProviderType _mapProvider(User user) {
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

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _datasource;
  AuthRepositoryImpl(this._datasource);

  UserEntity? _mapToEntity(User? firebaseUser) {
    if (firebaseUser == null) return null;
    return UserEntity(uid: firebaseUser.uid, emailVerified: firebaseUser.emailVerified, provider: _mapProvider(firebaseUser));
    
  }


  @override
  Stream<UserEntity?> get authStateChanges => _datasource.authStateChanges().map(_mapToEntity);

  @override
  Future<UserEntity?> getCurrentUser() async{
    final user = await _datasource.currentUser();
    return _mapToEntity(user);
  }

  @override
  Future<Either<AuthFailure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final rawUser=await _datasource.signInWithEmail(
        email: email,
        password: password
      );

      return Right(_mapToEntity(rawUser)!);
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
      final rawUser=await _datasource.signUpWithEmail(email: email, password: password,displayName: displayName);

      return Right(_mapToEntity(rawUser)!);
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
      return Right(_mapToEntity(rawUser)!);

    } on CancelledByUserFailure catch (e) {
      return Left(e);
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseError(e));
    } catch (_) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<AuthFailure, UserEntity>> signInWithApple() async {
    try {
      final rawUser = await _datasource.signInWithApple();
      return Right(_mapToEntity(rawUser)!); // 🛠️ Wrapped in your entity mapper
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseError(e));
    } catch (e) {
      // 🛠️ Handled native string checking fallback instead of unimported third-party exception types
      if (e.toString().contains('canceled')) {
        return const Left(CancelledByUserFailure());
      }
      return const Left(ServerFailure());
    }
  }


  @override
  Future<Either<AuthFailure, Unit>> reloadUser() async {
    try {
      await _datasource.reloadUser();
      return const Right(unit); // 🛠️ 'unit' comes from dartz, representing a void/success state
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
      default:
        return ServerFailure(e.message ?? 'Something went wrong.');
    }
  }
}