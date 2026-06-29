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

// 🚀 ADDED FOR PREMIUM & INITIAL STATE UI ACCESS CONTROLS:

class ContentPremiumLockedFailure extends BookFailure {
  const ContentPremiumLockedFailure([
    super.message = 'This content is locked. Upgrade to premium to read.',
  ]);
}

class ContentNetworkFailure extends BookFailure {
  const ContentNetworkFailure([
    super.message = 'Connection lost. Check your internet connection.',
  ]);
}