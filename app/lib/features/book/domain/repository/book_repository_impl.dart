import 'package:app/features/book/data/datasources/book_remote_datasource.dart';
import 'package:app/features/book/domain/entity/book_content_entity.dart';
import 'package:app/features/book/domain/entity/book_entity.dart';
import 'package:app/features/book/domain/entity/book_failure.dart';
import 'package:app/features/book/domain/repository/book_repository.dart';
import 'package:dartz/dartz.dart';

class BookRepositoryImpl implements BookRepository {
  final BookRemoteDatasource _datasource;

  BookRepositoryImpl(this._datasource);

  @override
  Future<Either<BookFailure, BookContent>> getContents(String uid) async {
    try {
      final booksContent = await _datasource.getContents(uid);
      return Right(booksContent);
    } catch (e,stack) {
      // print('hey pichu : $e');
      print('❌ FIRESTORE REPO ERROR: $e');
    print('📋 STACK TRACE: $stack');
      return const Left(BookServerFailure());
    }
  }

  @override
  Future<Either<BookFailure, List<Map<String, String>>>> getContentTitle(
    String bookId,
  ) async {
    try {
      final booksContent = await _datasource.getContentTitle(bookId);

      print('here is your data:${booksContent}');
      return Right(booksContent);
    } catch (e,stack) {
      print('❌ FIRESTORE REPO ERROR: $e');
    print('📋 STACK TRACE: $stack');
      // Catch block wildcard (_) ignores unused error variable warnings cleanly
      return const Left(BookServerFailure());
    }
  }
  @override
  Future<Either<BookFailure, List<Map<String, String>>>> getContentAudios(
    String bookId,
  ) async {
    try {
      final booksContent = await _datasource.getContentAudios(bookId);

      // print('here is your data:${booksContent}');
      return Right(booksContent);
    } catch (_) {
      // print('❌ FIRESTORE REPO ERROR: $e');
    // print('📋 STACK TRACE: $stack');
      // Catch block wildcard (_) ignores unused error variable warnings cleanly
      return const Left(BookServerFailure());
    }
  }

  @override
  Future<Either<BookFailure, List<BookEntity>>> getBooks() async {
    try {
      final books = await _datasource.getBooks();
      return Right(books);
    } catch (_) {
      // print('hey pichu : $e');
      return const Left(BookServerFailure());
    }
  }

  @override
  Future<Either<BookFailure, BookEntity>> getBookById(String bookId) async {
    try {
      final book = await _datasource.getBookById(bookId);

      if (book == null) {
        return const Left(BookNotFoundFailure());
      }

      return Right(book);
    } catch (e) {
      print('hey pichu : $e');
      return const Left(BookServerFailure());
    }
  }
}
