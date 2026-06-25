// features/book/presentation/provider/book_state.dart
import 'package:app/features/book/domain/entity/book_entity.dart';

class BookState {
  final List<BookEntity> books;
  final bool isLoading;
  final String? errorMessage;

  const BookState({
    this.books = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  BookState copyWith({
    List<BookEntity>? books,
    bool? isLoading,
    String? errorMessage,
  }) 
  {
    return BookState(
      books: books ?? this.books,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}