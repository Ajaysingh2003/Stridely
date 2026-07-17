import 'package:shared_preferences/shared_preferences.dart';

class BookmarkService {
  static const _key = 'user_bookmarks';


  static Future<void> toggleBookmark(String bookId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList(_key) ?? [];

    if (bookmarks.contains(bookId)) {
      bookmarks.remove(bookId);
    } else {
      bookmarks.add(bookId);
    }

    await prefs.setStringList(_key, bookmarks);
  }


  static Future<bool> isBookmarked(String bookId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList(_key) ?? [];
    return bookmarks.contains(bookId);
  }
}