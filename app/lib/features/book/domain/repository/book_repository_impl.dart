import 'package:app/features/book/data/datasources/book_remote_datasource.dart';
import 'package:app/features/book/domain/entity/book_content_entity.dart';
import 'package:app/features/book/domain/entity/book_entity.dart';
import 'package:app/features/book/domain/entity/book_failure.dart';
import 'package:app/features/book/domain/entity/books_response.dart';
import 'package:app/features/book/domain/entity/insights_entity.dart';
import 'package:app/features/book/domain/repository/book_repository.dart';
import 'package:app/features/home/domain/entity/category_entity.dart';
import 'package:app/features/home/domain/entity/collection_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/rendering.dart';

class BookRepositoryImpl implements BookRepository {
  final BookRemoteDatasource _datasource;

  BookRepositoryImpl(this._datasource);

  @override
  Future<Either<BookFailure, BookContent>> getContents(String uid) async {
    try {
      final booksContent = await _datasource.getContents(uid);
      return Right(booksContent);
    } catch (e, stack) {
      
      return const Left(BookServerFailure());
    }
  }

  @override
  Future<Either<BookFailure, List<Map<String, String>>>> getContentTitle(
    String bookId,
  ) async {
    try {
      final booksContent = await _datasource.getContentTitle(bookId);
      return Right(booksContent);
    } catch (e, stack) {
      
      return const Left(BookServerFailure());
    }
  }

  @override
  Future<Either<BookFailure, List<Map<String, String>>>> getChapters(
    String bookId,
  ) async {
    try {
      final booksContent = await _datasource.getChapters(bookId);
      return Right(booksContent);
    } catch (e, stack) {
      
      return const Left(BookServerFailure());
    }
  }

  @override
  Future<Either<PaginatedResponse<BookEntity>, BookFailure>> getFilteredBooks({
    String? categoryId,
    String? collectionId,
    String? searchQuery,
    int limit = 10,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      final paginatedResult = await _datasource.getFilteredBooks(
        categoryId: categoryId,
        collectionId: collectionId,
        searchQuery: searchQuery,
        limit: limit,
        lastDocument: lastDocument,
      );
      return Left(paginatedResult);
    } catch (e, stack) {
      
      return const Right(BookServerFailure());
    }
  }

  @override
  Future<Either<BookFailure, List<BookEntity>>> getBooks() async {
    try {
      final books = await _datasource.getBooks();
      return Right(books);
    } catch (e, stack) {
      
      return const Left(BookServerFailure());
    }
  }

  @override
  Future<Either<BookFailure, List<CollectionEntity>>> getCollections() async {
    try {
      final collection = await _datasource.getCollections();
      return Right(collection);
    } catch (e, stack) {
      
      return const Left(BookServerFailure());
    }
  }
  
  @override
  Future<Either<BookFailure, List<CategoryEntity>>> getCategory() async {
    try {
      final category = await _datasource.getCategories();
      return Right(category);
    } catch (e, stack) {
      
      return const Left(BookServerFailure());
    }
  }

  @override
  Future<Either<BookFailure, List<BookEntity>>> getFreeBooks() async {
    try {
      final books = await _datasource.getFreeBooks();
      return Right(books);
    } catch (e, stack) {
      
      return const Left(BookServerFailure());
    }
  }

  @override
  Future<Either<BookFailure, List<BookEntity>>> getBooksFromIds(List<String> bookIds) async {
    try {
      // FIXED: Now passing parameters down to correct datasource query mechanism
      final books = await _datasource.getBooksFromIds(bookIds);
      return Right(books);
    } catch (e, stack) {
      
      return const Left(BookServerFailure());
    }
  }

  @override
  Future<Either<BookFailure, List<BookEntity>>> getInsightes() async {
    try {
      final insights = await _datasource.getInsightes();
      return Right(insights);
    } catch (e, stack) {
      
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
    } catch (e, stack) {
      
      return const Left(BookServerFailure());
    }
  }
}