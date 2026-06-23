import 'package:app/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
import '../entities/auth_failure.dart';
import '../entities/user_entity.dart';


class SignInWithEmailParams {
  final String email;
  final String password;
  const SignInWithEmailParams({
    required this.email,
    required this.password,
  });
}

class SignInWithEmailUsecase {
  final AuthRepository _repository;
  const SignInWithEmailUsecase(this._repository);

  Future<Either<AuthFailure, UserEntity>> call(SignInWithEmailParams params) =>
      _repository.signInWithEmail(
        email: params.email,
        password: params.password,
      );
}