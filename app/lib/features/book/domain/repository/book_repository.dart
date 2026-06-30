import 'package:app/features/book/domain/entity/book_content_entity.dart';
import 'package:app/features/book/domain/entity/book_entity.dart';
import 'package:app/features/book/domain/entity/book_failure.dart';
import 'package:dartz/dartz.dart';

abstract class BookRepository {
  Future<Either<BookFailure, List<BookEntity>>> getBooks();

  Future<Either<BookFailure, BookContent>> getContents(String uid);
  Future<Either<BookFailure, List<Map<String, String>>>> getContentTitle(
    String bookId,
  );
  Future<Either<BookFailure, List<Map<String, String>>>> getChapters(
    String bookId,
  );
  Future<Either<BookFailure, BookEntity>> getBookById(String bookId);
}
