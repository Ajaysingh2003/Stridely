// import '../entities/user_entity.dart';
// import 'package:app/features/auth/domain/repository/book_repository.dart';
import 'package:app/features/book/domain/entity/book_entity.dart';
import 'package:app/features/book/domain/entity/book_failure.dart';
import 'package:app/features/book/domain/repository/book_repository.dart';
import 'package:dartz/dartz.dart';

class GetBooksByIdUseCase {
  final BookRepository _repository;
  const GetBooksByIdUseCase(this._repository);

  Future<Either<BookFailure, BookEntity>> call(String bookId) {
    return _repository.getBookById(bookId);
  }

}
