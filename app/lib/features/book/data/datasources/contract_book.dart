// import 'package:app/features/book/domain/entity/book_content_entity.dart';
// import 'package:app/features/book/domain/entity/book_entity.dart';
// import 'package:app/features/book/domain/entity/book_failure.dart';
// import 'package:dartz/dartz.dart';

// abstract class BookSourceContract {
  
//   Future<Either<BookFailure, List<BookEntity>>> getBooks();
  
//   Future<Either<BookFailure, BookEntity>> getBookById(String bookId);
  
//   Future<Either<BookFailure, BookContent>> getContents(String uid);

//   Future<List<Map<String, String>>> getContentTitle(String bookId);  
// }



import 'package:app/features/book/domain/entity/book_content_entity.dart';
import 'package:app/features/book/domain/entity/book_entity.dart';
import 'package:app/features/book/domain/entity/books_response.dart';
import 'package:app/features/book/domain/entity/insights_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BookSourceContract {

  Future<List<BookEntity>> getBooks();
  Future<PaginatedResponse<BookEntity>> getFilteredBooks({
    String? categoryId,
    String? collectionId,
    String? searchQuery,
    int limit = 10,
    DocumentSnapshot? lastDocument,
  });
  
  Future<List<BookEntity>> getFreeBooks();
  Future<InsightsEntity> getInsightes();
  
  Future<BookEntity?> getBookById(String bookId);
  Future<BookContent> getContents(String uid);

  Future<List<Map<String, String>>> getContentTitle(String bookId);  
  Future<List<Map<String, String>>> getContentAudios(String bookId);  
}