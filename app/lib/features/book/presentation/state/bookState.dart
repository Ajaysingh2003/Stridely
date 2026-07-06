import 'package:app/features/book/domain/entity/book_entity.dart';
import 'package:app/features/book/domain/entity/insights_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookState {
  final List<BookEntity> books;
  final List<BookEntity> freeBooks;
  final List<InsightsEntity> insights;
  final bool isLoading;
  final bool freeBooksLoading;
  final bool insightsLoading;

  final String? booksErrorMessage;
  final String? insightsErrorMessage;


  const BookState({
    this.books = const [],
    this.insights=const [],
    this.freeBooks = const [],
    this.freeBooksLoading=false,
    this.isLoading = false,
    this.booksErrorMessage,
    this.insightsErrorMessage,
    this.insightsLoading =false,
  });

  BookState copyWith({
    List<BookEntity>? books,
    List<BookEntity>? freeBooks,
    List<InsightsEntity>? insights,
    bool? isLoading,
    bool ? freeBooksLoading,
    bool ? insightsLoading,
    // We use an explicit fallback token checker structure for error handling
    // String? Function()? errorMessage, 
    String? Function()? booksErrorMessage,
    String? Function()? insightsErrorMessage,
  }) {
    return BookState(
      books: books ?? this.books,
      freeBooks: freeBooks ?? this.freeBooks,
      insightsLoading:insightsLoading?? this.insightsLoading,
      insights: insights ?? this.insights,
      isLoading: isLoading ?? this.isLoading,
      freeBooksLoading: freeBooksLoading ?? this.freeBooksLoading,
      // ── 🎯 FIXED: Allows explicitly resetting to null vs using old state ──
      booksErrorMessage: booksErrorMessage != null ? booksErrorMessage() : this.booksErrorMessage,
      insightsErrorMessage: insightsErrorMessage != null ? insightsErrorMessage() : this.insightsErrorMessage,
    );
  }
}

class BookContentTitleState {
  final List<Map<String, String>> titles;
  final bool isLoading;
  final String? errorMessage;

  const BookContentTitleState({
    this.titles = const [],
    this.isLoading = false,
    this.errorMessage,
  });


  BookContentTitleState copyWith({
    List<Map<String, String>>? titles,
    bool? isLoading,
    String? errorMessage,
  })
  
   {
    return BookContentTitleState(
      titles: titles ?? this.titles,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class BookContentChapterState {
  final List<Map<String, String>> chapters;
  final bool isLoading;
  final String? errorMessage;

  const BookContentChapterState({
    this.chapters = const [],
    this.isLoading = false,
    this.errorMessage,
  });


  BookContentChapterState copyWith({
    List<Map<String, String>>? chapters,
    bool? isLoading,
    String? errorMessage,
  })
  
   {
    return BookContentChapterState(
      chapters: chapters ?? this.chapters,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class FilterBookState {
  final List<BookEntity> books;
  final bool isLoading;
  final bool hasMore;
  final String? errorMessage;
  final DocumentSnapshot? lastDocument;
  
  const FilterBookState({
    this.books = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.lastDocument,
    this.errorMessage
  });

  // A helper method to easily modify properties while keeping the current state intact
  FilterBookState copyWith({
    List<BookEntity>? books,
    bool? isLoading,
    bool? hasMore,
    DocumentSnapshot? lastDocument,
     String? Function()? errorMessage,
  }) {
    return FilterBookState(
      books: books ?? this.books,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      lastDocument: lastDocument,
      errorMessage:  errorMessage != null ? errorMessage() : this.errorMessage
    );
  }
}