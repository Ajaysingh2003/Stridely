import 'package:app/features/book/data/datasources/book_remote_datasource.dart';
import 'package:app/features/book/domain/entity/book_entity.dart';
import 'package:app/features/book/domain/entity/book_failure.dart';
import 'package:app/features/book/domain/repository/book_repository.dart';
import 'package:app/features/book/domain/repository/book_repository_impl.dart';
import 'package:app/features/book/domain/usercases/get_books.dart';
import 'package:app/features/book/domain/usercases/get_books_by_id.dart';
import 'package:app/features/book/presentation/provider/books_controller.dart';
import 'package:app/features/book/presentation/state/bookState.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
final firebaseFirestoreProvider = Provider((ref) => FirebaseFirestore.instance);

final authDataSourceProvider = Provider(
  (ref) => BookRemoteDatasource(
    ref.watch(firebaseFirestoreProvider),
  ),
);



final booksRepositoryProvider = Provider<BookRepository>(
  (ref) => BookRepositoryImpl(ref.watch(authDataSourceProvider)),
);



final getBooksUseCaseProvider = Provider(
  (ref) => GetBooksUseCase(ref.watch(booksRepositoryProvider)),
);
final getBookUseCaseProvider = Provider(
  (ref) => GetBooksByIdUseCase(ref.watch(booksRepositoryProvider)),
);



final booksControllerProvider =
    StateNotifierProvider<BooksController, BookState>((ref) {
      return BooksController(
        ref.watch(getBooksUseCaseProvider),
      );
    });



final singleBookProvider = FutureProvider.family<Either<BookFailure, BookEntity>, String>((ref, bookId) async {
  // Grab the single-book lookup use case directly from your DI setup
  final getBookByIdUseCase = ref.watch(getBookUseCaseProvider);
  
  // Return the evaluation pipeline result
  return await getBookByIdUseCase.call(bookId);
});