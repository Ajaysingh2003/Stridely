import 'package:app/features/bookmark/repository/repository.dart';
import 'package:app/features/bookmark/repository/repository_implementation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final bookmarkRepositoryProvider = Provider<BookmarkRepository>((ref) {
  return LocalBookmarkRepository();
});

final bookmarkNotifierProvider = StateNotifierProvider<BookmarkNotifier, List<String>>((ref) {
  final repo = ref.watch(bookmarkRepositoryProvider);
  return BookmarkNotifier(repo);
});

class BookmarkNotifier extends StateNotifier<List<String>> {
  final BookmarkRepository repo;
  
  BookmarkNotifier(this.repo) : super([]) {
    _load();
  }

  Future<void> _load() async {
    state = await repo.getBookmarkedIds();
  }

  Future<void> toggle(String bookId) async {
    await repo.toggleBookmark(bookId);
    state = await repo.getBookmarkedIds(); // Rebuild UI automatically
  }
}