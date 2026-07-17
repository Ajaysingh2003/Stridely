abstract class BookmarkRepository {
  Future<void> toggleBookmark(String bookId);
  Future<bool> isBookmarked(String bookId);
  Future<List<String>> getBookmarkedIds();
}