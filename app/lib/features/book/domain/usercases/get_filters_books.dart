import 'package:app/features/book/domain/entity/book_entity.dart';
import 'package:app/features/book/domain/entity/book_failure.dart';
import 'package:app/features/book/domain/entity/books_response.dart';
import 'package:app/features/book/domain/repository/book_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';


class GetFiltersBooksUseCase {
  final BookRepository _repository;
  const GetFiltersBooksUseCase(this._repository);

  Future<Either<PaginatedResponse<BookEntity>, BookFailure>> call(FilterBookParams params) {
    return _repository.getFilteredBooks(
      categoryId: params.categoryId,
      collectionId: params.collectionId,
      searchQuery: params.searchQuery,
      limit: params.limit,
      lastDocument: params.lastDocument,
    );
  }
}

// ── 📦 CLEAN ARCHITECTURE PARAMETER HOLDER CONTAINER ──
class FilterBookParams {
  final String? categoryId;
  final String? collectionId;
  final String? searchQuery;
  final int limit;
  final DocumentSnapshot? lastDocument;

  const FilterBookParams({
    this.categoryId,
    this.collectionId,
    this.searchQuery,
    this.limit = 10,
    this.lastDocument,
  });
}