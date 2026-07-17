import 'package:app/features/book/domain/entity/book_entity.dart';
import 'package:app/features/book/domain/entity/insights_entity.dart';
import 'package:app/features/home/domain/entity/category_entity.dart';
import 'package:app/features/home/domain/entity/collection_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookState {
  final List<BookEntity> books;
  final List<BookEntity> freeBooks;
  final List<InsightsEntity> insights;

  final List<CollectionEntity> collections;

  final bool isLoading;
  final bool freeBooksLoading;
  final bool insightsLoading;
  final bool collectionLoading;

  final String? booksErrorMessage;
  final String? insightsErrorMessage;
  final String? collectionsErrorMessage;

  final List<CategoryEntity> categories;
  final String? categoryError;
  final bool categoryLoading;

  final List<BookEntity>? bookmarkBooks;

  final  String?  bookmarkError;

  final  bool bookmarkDataLoading;

  

  const BookState({
    this.bookmarkBooks,
    this.bookmarkError,
    this.bookmarkDataLoading =false,
    this.books = const [],
    this.insights = const [],
    this.freeBooks = const [],
    this.freeBooksLoading = false,
    this.isLoading = false,
    this.booksErrorMessage,
    this.insightsErrorMessage,
    this.insightsLoading = false,
    this.collectionLoading = false,
    this.collections = const [],
    this.collectionsErrorMessage,
    this.categories = const [],
    this.categoryError,
    this.categoryLoading = false,
  });

  BookState copyWith({
    List<BookEntity>? books,
    List<BookEntity>? freeBooks,
    List<InsightsEntity>? insights,
    bool? isLoading,
    bool? freeBooksLoading,
    bool? insightsLoading,
    String? Function()? booksErrorMessage,
    String? Function()? insightsErrorMessage,
    String? Function()? collectionsErrorMessage,
    bool? collectionLoading,
    List<CollectionEntity>? collections,

    String? Function()? categoryError,

    bool? categoryLoading,

    List<CategoryEntity>? categories,


    List<BookEntity>? bookmarkBooks,

    String? Function()? bookmarkError,

    bool? bookmarkDataLoading

  }) {
    return BookState(
      
      bookmarkBooks:bookmarkBooks ?? this.bookmarkBooks,
      bookmarkDataLoading:bookmarkDataLoading ?? this.bookmarkDataLoading,
      bookmarkError: bookmarkError != null? bookmarkError() : this.bookmarkError,
      books: books ?? this.books,
      freeBooks: freeBooks ?? this.freeBooks,
      insightsLoading: insightsLoading ?? this.insightsLoading,
      insights: insights ?? this.insights,
      isLoading: isLoading ?? this.isLoading,
      freeBooksLoading: freeBooksLoading ?? this.freeBooksLoading,
      booksErrorMessage: booksErrorMessage != null
          ? booksErrorMessage()
          : this.booksErrorMessage,
      insightsErrorMessage: insightsErrorMessage != null
          ? insightsErrorMessage()
          : this.insightsErrorMessage,
      collections: collections ?? this.collections,
      collectionLoading: collectionLoading ?? this.collectionLoading,
      collectionsErrorMessage: collectionsErrorMessage != null
          ? collectionsErrorMessage()
          : this.collectionsErrorMessage,

      categoryError: categoryError != null
          ? categoryError()
          : this.categoryError,

      categoryLoading: categoryLoading ?? this.categoryLoading
      ,categories: categories ?? this.categories
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
  }) {
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
  }) {
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
  final int totalCount;
  final String? errorMessage;
  final DocumentSnapshot? lastDocument;

  const FilterBookState({
    this.books = const [],
    this.totalCount = 0,
    this.isLoading = false,
    this.hasMore = true,
    this.lastDocument,
    this.errorMessage,
  });

  FilterBookState copyWith({
    List<BookEntity>? books,
    bool? isLoading,
    bool? hasMore,
    DocumentSnapshot? lastDocument,
    String? Function()? errorMessage,
    int? totalCount,
  }) {
    return FilterBookState(
      books: books ?? this.books,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      lastDocument: lastDocument,
      totalCount: this.totalCount,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
