import '../entities/user_entity.dart';
import 'package:app/features/auth/domain/repository/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository _repository;
  const GetCurrentUserUseCase(this._repository);

  Future<UserEntity?> call() => _repository.getCurrentUser();
  Stream<UserEntity?> stream() => _repository.authStateChanges;
}