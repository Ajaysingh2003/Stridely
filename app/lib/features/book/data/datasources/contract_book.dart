import 'package:app/features/book/domain/entity/book_entity.dart';
import 'package:app/features/book/domain/entity/book_failure.dart';
import 'package:dartz/dartz.dart';

abstract class BookSourceContract {

  Future<Either<BookFailure, List<BookEntity>>> getBooks();
  
  Future<Either<BookFailure, BookEntity>> getBookById(String bookId);
  
}
