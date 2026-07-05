// features/book/presentation/provider/book_state.dart
import 'package:app/features/book/domain/entity/book_entity.dart';
class BookState {
  final List<BookEntity> books;
  final List<BookEntity> freeBooks; // ── 🎯 DEDICATED FREE BOOKS SLOT ──
  final bool isLoading;
  final String? errorMessage;

  const BookState({
    this.books = const [],
    this.freeBooks = const [], // Initialized cleanly as empty array matrix
    this.isLoading = false,
    this.errorMessage,
  });

  BookState copyWith({
    List<BookEntity>? books,
    List<BookEntity>? freeBooks,
    bool? isLoading,
    // We use an explicit fallback token checker structure for error handling
    String? Function()? errorMessage, 
  }) {
    return BookState(
      books: books ?? this.books,
      freeBooks: freeBooks ?? this.freeBooks, // Handles separate stream merges smoothly
      isLoading: isLoading ?? this.isLoading,
      // ── 🎯 FIXED: Allows explicitly resetting to null vs using old state ──
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
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

