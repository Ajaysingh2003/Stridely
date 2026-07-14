import 'package:app/features/book/domain/entity/book_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookListState {
  final List<BookEntity> books;
  final bool isLoading;
  final bool hasMore;
  final String? errorMessage;
  final DocumentSnapshot? lastDocument;

  BookListState({
    this.books = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.errorMessage = "",
    this.lastDocument,
  });

  BookListState copyWith({
    List<BookEntity>? books,
    bool? isLoading,
    bool? hasMore,
    String? Function()? errorMessage,
    DocumentSnapshot? lastDocument,
  }) {
    return BookListState(
      books: books ?? this.books,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      lastDocument: lastDocument ?? this.lastDocument,
    );
  }
}


class SearchBookListState {
  final List<BookEntity> books;
  final bool isLoading;
  final String? errorMessage;

  SearchBookListState({
    this.books = const [],
    this.isLoading = false,
    this.errorMessage = "",
  });

  SearchBookListState copyWith({
    List<BookEntity>? books,
    bool? isLoading,
    String? Function()? errorMessage,
  }) {
    return SearchBookListState(
      books: books ?? this.books,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}



