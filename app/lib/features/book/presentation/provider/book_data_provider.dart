import 'package:app/features/book/data/datasources/book_remote_datasource.dart';
import 'package:app/features/book/domain/entity/book_content_entity.dart';
import 'package:app/features/book/domain/entity/book_entity.dart';
import 'package:app/features/book/domain/entity/book_failure.dart';
import 'package:app/features/book/domain/repository/book_repository.dart';
import 'package:app/features/book/domain/repository/book_repository_impl.dart';
import 'package:app/features/book/domain/usercases/get_books.dart';
import 'package:app/features/book/domain/usercases/get_books_by_id.dart';
import 'package:app/features/book/domain/usercases/get_content_audio.dart';
import 'package:app/features/book/domain/usercases/get_content_title.dart';
import 'package:app/features/book/domain/usercases/get_contents.dart';
import 'package:app/features/book/domain/usercases/get_filters_books.dart';
import 'package:app/features/book/domain/usercases/get_free_books.dart';
import 'package:app/features/book/domain/usercases/get_insights.dart';
import 'package:app/features/book/presentation/provider/books_controller.dart';
import 'package:app/features/book/presentation/state/all_book_list_State.dart';
import 'package:app/features/book/presentation/state/bookState.dart';
import 'package:app/features/home/domain/usecase/get_books_from_ids.dart';
import 'package:app/features/home/domain/usecase/get_category_usecase.dart';
import 'package:app/features/home/domain/usecase/get_collection_usecase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final firebaseFirestoreProvider = Provider((ref) => FirebaseFirestore.instance);

final authDataSourceProvider = Provider(
  (ref) => BookRemoteDatasource(ref.watch(firebaseFirestoreProvider)),
);

final booksRepositoryProvider = Provider<BookRepository>(
  (ref) => BookRepositoryImpl(ref.watch(authDataSourceProvider)),
);

final getBooksUseCaseProvider = Provider(
  (ref) => GetBooksUseCase(ref.watch(booksRepositoryProvider)),
);

final getContentChaptersUseCaseProvider = Provider(
  (ref) => GetContentChaptersUseCase(ref.watch(booksRepositoryProvider)),
);

final getFreeBooksUseCaseProvider = Provider(
  (ref) => GetFreeBooksUseCase(ref.watch(booksRepositoryProvider)),
);

final getInsightsUseCaseProvider = Provider(
  (ref) => GetInsightsUseCase(ref.watch(booksRepositoryProvider)),
);

final getBookUseCaseProvider = Provider(
  (ref) => GetBooksByIdUseCase(ref.watch(booksRepositoryProvider)),
);

final getBookContentUseCaseProvider = Provider(
  (ref) => GetContentUseCase(ref.watch(booksRepositoryProvider)),
);

final getContentTitleUseCaseProvider = Provider(
  (ref) => GetContentTitleUseCase(ref.watch(booksRepositoryProvider)),
);

final getFilterdUseCaseProvider = Provider(
  (ref) => GetFiltersBooksUseCase(ref.watch(booksRepositoryProvider)),
);

final getCollectionUseCaseProvider = Provider(
  (ref) => GetCollectionUseCase(ref.watch(booksRepositoryProvider)),
);

final getCategoryUseCaseProvider = Provider(
  (ref) => GetCategoryUsecase(ref.watch(booksRepositoryProvider)),
);

final getBooksFromIdsUseCaseProvider = Provider(
  (ref) => GetBooksFromIdsUsecase(ref.watch(booksRepositoryProvider)),
);



final booksControllerProvider =
    StateNotifierProvider<BooksController, BookState>((ref) {
      return BooksController(
        ref.watch(getBooksUseCaseProvider),
        ref.watch(getFreeBooksUseCaseProvider),
        ref.watch(getInsightsUseCaseProvider),
        ref.watch(getCollectionUseCaseProvider),
        ref.watch(getCategoryUseCaseProvider),
        ref.watch(getBooksFromIdsUseCaseProvider),
        


      );
    });

final filterdBooksControllerProvider =
    StateNotifierProvider.family<
      FiltersBooksController,
      FilterBookState,
      String
    >((ref, categoryId) {
      return FiltersBooksController(
        ref.watch(getFilterdUseCaseProvider),
        categoryId,
        null,
      );
    });

final filterdBooksCollectionControllerProvider =
    StateNotifierProvider.family<
      FiltersBooksController,
      FilterBookState,
      String
    >((ref, collectionId) {
      return FiltersBooksController(
        ref.watch(getFilterdUseCaseProvider),
        null,
        collectionId,
      );
    });

final searchBooksControllerProvider =
    StateNotifierProvider.autoDispose<SearchBooksController, SearchBookListState>((ref) {
  final useCase = ref.watch(getFilterdUseCaseProvider);
  return SearchBooksController(useCase);
});

final filteredBooks =
    StateNotifierProvider.family<
      FiltersBooksController,
      FilterBookState,
      String
    >((ref, collectionId) {
      return FiltersBooksController(
        ref.watch(getFilterdUseCaseProvider),
        null,
        collectionId,
      );
    });

final singleBookProvider =
    FutureProvider.family<Either<BookFailure, BookEntity>, String>((
      ref,
      bookId,
    ) async {
      // Grab the single-book lookup use case directly from your DI setup
      final getBookByIdUseCase = ref.watch(getBookUseCaseProvider);

      // Return the evaluation pipeline result
      return await getBookByIdUseCase.call(bookId);
    });

// final singleBookContentProvider = FutureProvider.family<Either<BookFailure, BookContent>, String>((ref, bookId) async {
//   // Grab the single-book lookup use case directly from your DI setup
//   final getBookContentByBookIdUseCase = ref.watch(getBookContentUseCaseProvider);

//   // Return the evaluation pipeline result
//   return await getBookContentByBookIdUseCase.call(bookId);
// });

final singleBookContentProvider = FutureProvider.family<BookContent, String>((
  ref,
  bookId,
) async {
  final getBookContentByBookIdUseCase = ref.watch(
    getBookContentUseCaseProvider,
  );

  final Either<BookFailure, BookContent> result =
      await getBookContentByBookIdUseCase.call(bookId);

  // 🎯 Unpack the functional Either structure cleanly here
  return result.fold((failure) => throw failure, (content) => content);
});

final bookTitleControllerProvider =
    StateNotifierProvider.family<
      BookTitleController,
      BookContentTitleState,
      String
    >((ref, bookId) {
      final useCase = ref.watch(getContentTitleUseCaseProvider);
      return BookTitleController(useCase, bookId);
    });

// final bookContentAudiosControllerProvider = StateNotifierProvider.family<BookContentAudioController, BookContentAudioState, String>((ref, bookId) {
//   final useCase = ref.watch(getContentAudiosUseCaseProvider);
//   return BookContentAudioController(useCase)..loadBookaudios(bookId);
// });

final bookContentChaptersControllerProvider =
    StateNotifierProvider.family<
      BookContentChapterController,
      BookContentChapterState,
      String
    >((ref, bookId) {
      // 1. Fetch your clean background data transmission use case
      final useCase = ref.watch(getContentChaptersUseCaseProvider);

      // 2. Instantiate your actual CONTROLLER notifier (pass the useCase dependencies if needed)
      final controller = BookContentChapterController(useCase);

      // 3. Trigger the data fetch lifecycle method cleanly using your public method name
      // (Replace 'loadBookAudios' or 'fetchChapters' with your actual method name inside your controller)
      controller.loadChapters(bookId);

      return controller;
    });

final allBooksControllerProvider =
    StateNotifierProvider<AllBooksController, BookListState>((ref) {
      return AllBooksController(ref.watch(getFilterdUseCaseProvider));
    });
