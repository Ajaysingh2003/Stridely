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

abstract class BookSourceContract {
  // 🚀 FIXED: Removed the Either wrappers from the Data Source layer
  Future<List<BookEntity>> getBooks();
  
  Future<BookEntity?> getBookById(String bookId);
  
  Future<BookContent> getContents(String uid);

  Future<List<Map<String, String>>> getContentTitle(String bookId);  
  Future<List<Map<String, String>>> getContentAudios(String bookId);  
}