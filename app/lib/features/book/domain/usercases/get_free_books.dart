import 'package:app/features/book/domain/entity/book_entity.dart';
import 'package:app/features/book/domain/entity/book_failure.dart';
import 'package:app/features/book/domain/repository/book_repository.dart';
import 'package:dartz/dartz.dart';

class GetFreeBooksUseCase {
  final BookRepository _repository;
  const GetFreeBooksUseCase(this._repository);

  Future<Either<BookFailure, List<BookEntity>>> call() {
    return _repository.getFreeBooks();
  }

}
