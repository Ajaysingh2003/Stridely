import 'package:app/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
import '../entities/auth_failure.dart';
import '../entities/user_entity.dart';


class SignUpWithEmailParams {
  final String email;
  final String password;
  final String? displayName;
  const SignUpWithEmailParams({
    required this.email,
    required this.password,
    this.displayName,
  });
}

class SignUpWithEmailUsecase {
  final AuthRepository _repository;
  const SignUpWithEmailUsecase(this._repository);

  Future<Either<AuthFailure, UserEntity>> call(SignUpWithEmailParams params) =>
      _repository.signUpWithEmail(
        email: params.email,
        password: params.password,
        displayName: params.displayName,
      );
}