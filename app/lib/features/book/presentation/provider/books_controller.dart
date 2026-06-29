import 'package:app/features/book/domain/usercases/get_books.dart';
import 'package:app/features/book/domain/usercases/get_books_by_id.dart';
import 'package:app/features/book/domain/usercases/get_content_audio.dart';
import 'package:app/features/book/domain/usercases/get_content_title.dart';
import 'package:app/features/book/presentation/state/bookState.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/legacy.dart';

class BooksController extends StateNotifier<BookState> {

  final GetBooksUseCase _getBooksUsecase;
  // final GetContentTitleUseCase _contentTitleUseCase;
  BooksController(

    this._getBooksUsecase,
    // this._contentTitleUseCase
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




class BookTitleController extends StateNotifier<BookContentTitleState> {
  final GetContentTitleUseCase _contentTitleUseCase;

  BookTitleController(this._contentTitleUseCase) : super(const BookContentTitleState());

  Future<void> loadBookTitles(String bookId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    final result = await _contentTitleUseCase.call(bookId);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false, 
        errorMessage: failure.message,
      ),
      (titlesList) => state = state.copyWith(
        isLoading: false, 
        titles: titlesList,
      ),
    );
  }
}

class BookContentAudioController extends StateNotifier<BookContentAudioState> {
  final GetContentAudioUseCase _contentAudioUseCase;

  BookContentAudioController(this._contentAudioUseCase) : super(const BookContentAudioState());

  Future<void> loadBookaudios(String bookId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    final result = await _contentAudioUseCase.call(bookId);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false, 
        errorMessage: failure.message,
      ),
      (audioList) => state = state.copyWith(
        isLoading: false, 
        audios: audioList,
      ),
    );
  }
}