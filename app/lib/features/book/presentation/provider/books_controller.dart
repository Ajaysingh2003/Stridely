import 'package:app/features/book/domain/usercases/get_books.dart';
// import 'package:app/features/book/domain/usercases/get_books_by_id.dart';
import 'package:app/features/book/domain/usercases/get_content_audio.dart';
import 'package:app/features/book/domain/usercases/get_content_title.dart';
import 'package:app/features/book/domain/usercases/get_filters_books.dart';
import 'package:app/features/book/domain/usercases/get_free_books.dart';
import 'package:app/features/book/domain/usercases/get_insights.dart';
import 'package:app/features/book/presentation/state/all_book_list_State.dart';
import 'package:app/features/book/presentation/state/bookState.dart';
import 'package:app/features/home/domain/usecase/get_collection_usecase.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/legacy.dart';

class BooksController extends StateNotifier<BookState> {
  final GetBooksUseCase _getBooksUsecase;
  final GetFreeBooksUseCase _getFreeBooksUsecase;
  final GetInsightsUseCase _getInsightsUseCase;
  final GetCollectionUseCase _getCollectionUseCase;

  BooksController(
    this._getBooksUsecase,
    this._getFreeBooksUsecase,
    this._getInsightsUseCase,
    this._getCollectionUseCase,
  ) : super(const BookState());

  Future<void> loadAllBooks() async {
    state = state.copyWith(isLoading: true, booksErrorMessage: null);
    final result = await _getBooksUsecase.call();

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        booksErrorMessage: () => failure.message,
      ),
      (booksList) => state = state.copyWith(isLoading: false, books: booksList),
    );
  }

  Future<void> loadInsights() async {
    state = state.copyWith(insightsLoading: true, insightsErrorMessage: null);
    final result = await _getInsightsUseCase.call();

    result.fold(
      (failure) => state = state.copyWith(
        insightsLoading: false,
        insightsErrorMessage: () => failure.message,
      ),
      (insightsList) => state = state.copyWith(
        insightsLoading: false,
        insights: insightsList,
      ),
    );
  }

  Future<void> loadFreeBooks() async {
    state = state.copyWith(freeBooksLoading: true, booksErrorMessage: null);

    final result = await _getFreeBooksUsecase.call();

    result.fold(
      (failure) => state = state.copyWith(
        freeBooksLoading: false,
        booksErrorMessage: () => failure.message,
      ),
      (booksList) => state = state.copyWith(
        freeBooksLoading: false,
        freeBooks: booksList,
        booksErrorMessage: () => null,
      ),
    );
  }

  Future<void> loadCollection() async {
    state = state.copyWith(
      collectionLoading: true,
      collectionsErrorMessage: null,
    );

    final result = await _getCollectionUseCase.call();

    result.fold(
      (failure) => state = state.copyWith(
        collectionLoading: false,
        collectionsErrorMessage: () => failure.message,
      ),
      (collectionList) => state = state.copyWith(
        collectionLoading: false,
        collections: collectionList,
        collectionsErrorMessage: () => null,
      ),
    );
  }
}

// class BookTitleController extends StateNotifier<BookContentTitleState> {
//   final GetContentTitleUseCase _contentTitleUseCase;
//   final String bookId;
//   BookTitleController(this._contentTitleUseCase, this.bookId)
//     : super(const BookContentTitleState());

//   Future<void> loadBookTitles(String bookId) async {
//     state = state.copyWith(isLoading: true, errorMessage: null);

//     final result = await _contentTitleUseCase.call(bookId);

//     result.fold(
//       (failure) => state = state.copyWith(
//         isLoading: false,
//         errorMessage: failure.message,
//       ),
//       (titlesList) =>
//           state = state.copyWith(isLoading: false, titles: titlesList),
//     );
//   }
// }

class BookTitleController extends StateNotifier<BookContentTitleState> {
  final GetContentTitleUseCase _contentTitleUseCase;
  final String bookId;

  BookTitleController(this._contentTitleUseCase, this.bookId)
    : super(const BookContentTitleState()) {
    // 🚨 FIX: Call the method here so it triggers automatically when the book changes
    loadBookTitles(bookId);
  }

  Future<void> loadBookTitles(String bookId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _contentTitleUseCase.call(bookId);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (titlesList) =>
          state = state.copyWith(isLoading: false, titles: titlesList),
    );
  }
}

class BookContentChapterController
    extends StateNotifier<BookContentChapterState> {
  final GetContentChaptersUseCase _contentChapterUseCase;

  BookContentChapterController(this._contentChapterUseCase)
    : super(const BookContentChapterState());

  Future<void> loadChapters(String bookId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _contentChapterUseCase.call(bookId);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (chapterList) =>
          state = state.copyWith(isLoading: false, chapters: chapterList),
    );
  }
}

class FiltersBooksController extends StateNotifier<FilterBookState> {
  final GetFiltersBooksUseCase _getFiltersBooksUseCase;
  final String? categoryId;
  final String? collectionId;
  FiltersBooksController(
    this._getFiltersBooksUseCase,
    this.categoryId,
    this.collectionId,
  ) : super(const FilterBookState());

  Future<void> loadFilterdBooks({
    String? categoryId,
    String? collectionId,
    String? searchQuery,
    int limit = 10,
    bool isRefresh = false,
  }) async {
    // Prevent double-fetching if a network call is already active
    if (state.isLoading || (!state.hasMore && !isRefresh)) return;

    // Set loading state and clear list if performing a fresh filter refresh reset
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      books: isRefresh ? const [] : state.books,
    );

    // ── 🎯 THE FIX: Package parameters into your Clean Architecture Params object ──
    final result = await _getFiltersBooksUseCase.call(
      FilterBookParams(
        categoryId: categoryId,
        collectionId: collectionId,
        searchQuery: searchQuery,
        limit: limit,
        lastDocument: isRefresh ? null : state.lastDocument,
      ),
    );

    // ── 🎯 THE FIX: fold(left, right) -> left is PaginatedResponse (Success), right is BookFailure ──
    result.fold(
      (paginatedResponse) {
        state = state.copyWith(
          isLoading: false,
          totalCount: state.totalCount,
          books: [...state.books, ...paginatedResponse.items],
          lastDocument: paginatedResponse.lastDocument,
          hasMore: paginatedResponse.hasMore,
        );
      },
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: () => failure.message,
          hasMore: false,
        );
      },
    );
  }
}

// class AllBooksController extends StateNotifier<BookListState> {
//   final GetFiltersBooksUseCase _getFiltersBooksUseCase;
//   AllBooksController(this._getFiltersBooksUseCase)
//     : super( BookListState());

//   Future<void> loadFilterdBooks({
//     String? searchQuery,
//     int limit = 10,
//     bool isRefresh = false,
//   }) async {
//     // Prevent double-fetching if a network call is already active
//     if (state.isLoading || (!state.hasMore && !isRefresh)) return;

//     // Set loading state and clear list if performing a fresh filter refresh reset
//     state = state.copyWith(
//       isLoading: true,
//       errorMessage: null,
//       books: isRefresh ? const [] : state.books,
//     );

//     // ── 🎯 THE FIX: Package parameters into your Clean Architecture Params object ──
//     final result = await _getFiltersBooksUseCase.call(
//       FilterBookParams(
//         searchQuery: searchQuery,
//         limit: limit,
//         lastDocument: isRefresh ? null : state.lastDocument,
//       ),
//     );

//     // ── 🎯 THE FIX: fold(left, right) -> left is PaginatedResponse (Success), right is BookFailure ──
//     result.fold(
//       (paginatedResponse) {
//         state = state.copyWith(
//           isLoading: false,
//           books: [...state.books, ...paginatedResponse.items],
//           lastDocument: paginatedResponse.lastDocument,
//           hasMore: paginatedResponse.hasMore,
//         );
//       },
//       (failure) {
//         state = state.copyWith(
//           isLoading: false,
//           errorMessage: ()=>failure.message,
//           hasMore: false,
//         );
//       },
//     );
//   }
// }

class AllBooksController extends StateNotifier<BookListState> {
  final GetFiltersBooksUseCase _getFiltersBooksUseCase;
  AllBooksController(this._getFiltersBooksUseCase) : super(BookListState());

  Future<void> loadFilterdBooks({bool isRefresh = false}) async {
    // 1. The Gatekeeper
    if (state.isLoading) return;
    if (!isRefresh && !state.hasMore) return;

    // 2. Synchronous update (Blocks subsequent calls)
    state = state.copyWith(
      isLoading: true,
      books: isRefresh ? [] : state.books,
    );

    final result = await _getFiltersBooksUseCase.call(
      FilterBookParams(
        limit: 10,
        lastDocument: isRefresh ? null : state.lastDocument,
      ),
    );

    result.fold(
      (paginatedResponse) {
        state = state.copyWith(
          isLoading: false, // 3. Re-enable after data arrives
          books: [...state.books, ...paginatedResponse.items],
          lastDocument: paginatedResponse.lastDocument,
          hasMore: paginatedResponse.hasMore,
        );

        print("========== LOAD ==========");
        print("Current books: ${state.books.length}");
        print("Current cursor: ${state.lastDocument?.id}");
        print("Refresh: $isRefresh");
        
      },
      (failure) {
        state = state.copyWith(isLoading: false, hasMore: false);
      },
    );
  }
}
