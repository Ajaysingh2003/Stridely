import 'package:app/features/book/domain/entity/book_content_entity.dart';
import 'package:app/features/book/domain/entity/book_entity.dart';
import 'package:app/features/book/domain/entity/book_failure.dart';
import 'package:app/features/book/domain/entity/books_response.dart';
import 'package:app/features/book/domain/entity/insights_entity.dart';
import 'package:app/features/home/domain/entity/collection_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract class BookRepository {
  Future<Either<BookFailure, List<BookEntity>>> getBooks();
  Future<Either<BookFailure, List<BookEntity>>> getFreeBooks();

  Future<Either<PaginatedResponse<BookEntity>,BookFailure>> getFilteredBooks({
    String? categoryId,
    String? collectionId,
    String? searchQuery,
    int limit = 10,
    DocumentSnapshot? lastDocument,
  });
  

  Future<Either<BookFailure, List<InsightsEntity>>> getInsightes();
  Future<Either<BookFailure, List<CollectionEntity>>> getCollections();

  Future<Either<BookFailure, BookContent>> getContents(String uid);
  Future<Either<BookFailure, List<Map<String, String>>>> getContentTitle(
    String bookId,
  );
  Future<Either<BookFailure, List<Map<String, String>>>> getChapters(
    String bookId,
  );
  Future<Either<BookFailure, BookEntity>> getBookById(String bookId);
}
