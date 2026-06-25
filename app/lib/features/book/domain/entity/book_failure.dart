abstract class BookFailure {
  final String message;

  const BookFailure(this.message);
  
}

class BookServerFailure extends BookFailure {
  
  const BookServerFailure([super.message = 'Something went wrong.']);
}

class BookNotFoundFailure extends BookFailure {
  const BookNotFoundFailure([super.message = 'Book not found.']);
}