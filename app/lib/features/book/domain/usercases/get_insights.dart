import 'package:app/features/book/domain/entity/book_entity.dart';
import 'package:app/features/book/domain/entity/book_failure.dart';
import 'package:app/features/book/domain/entity/insights_entity.dart';
import 'package:app/features/book/domain/repository/book_repository.dart';
import 'package:dartz/dartz.dart';

class GetInsightsUseCase {
  final BookRepository _repository;
  const GetInsightsUseCase(this._repository);

  Future<Either<BookFailure, List<BookEntity>>> call() {
    return _repository.getInsightes();
  }

}
