import 'package:app/features/bookmark/repository/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalBookmarkRepository implements BookmarkRepository {
  static const _key = 'user_bookmarks';

  @override
  Future<void> toggleBookmark(String bookId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList(_key) ?? [];
    
    if (bookmarks.contains(bookId)) {
      bookmarks.remove(bookId);
    } else {
      bookmarks.add(bookId);
    }
    await prefs.setStringList(_key, bookmarks);
  }

  @override
  Future<bool> isBookmarked(String bookId) async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_key) ?? []).contains(bookId);
  }

  @override
  Future<List<String>> getBookmarkedIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }
}