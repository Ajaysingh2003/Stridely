import 'package:app/features/book/domain/entity/book_entity.dart';
// import 'package:app/features/book/presentation/provider/book_data_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

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


