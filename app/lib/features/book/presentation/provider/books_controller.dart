import 'package:app/features/book/domain/usercases/get_books.dart';
import 'package:app/features/book/domain/usercases/get_books_by_id.dart';
import 'package:app/features/book/presentation/state/bookState.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/legacy.dart';

class BooksController extends StateNotifier<BookState> {

  final GetBooksUseCase _getBooksUsecase;

  BooksController(

    this._getBooksUsecase,
  ) : super(const BookState());


  Future<void> loadAllBooks() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _getBooksUsecase.call();

    result.fold(
      (failure) => state = state.copyWith(isLoading: false, errorMessage: failure.message),
      (booksList) => state = state.copyWith(isLoading: false, books: booksList),
    );
  }
}