import 'package:app/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
import '../entities/auth_failure.dart';
import '../entities/user_entity.dart';

class SignInWithGoogleUseCase {
  final AuthRepository _repository;
  const SignInWithGoogleUseCase(this._repository);

  Future<Either<AuthFailure, UserEntity>> call() =>
      _repository.signInWithGoogle();
}