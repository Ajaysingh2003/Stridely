import 'package:app/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
import '../entities/auth_failure.dart';
import '../entities/user_entity.dart';

class DeleteAccountUseCase {
  final AuthRepository _repository;
  const DeleteAccountUseCase(this._repository);

  Future<void> call() => _repository.delete();
}

