import 'package:app/core/func/Navigate.dart';
import 'package:app/core/loader.dart';
import 'package:app/features/book/domain/entity/book_entity.dart';
import 'package:app/features/book/presentation/provider/book_data_provider.dart';
import 'package:app/features/book/presentation/screen/book_screen.dart';
import 'package:app/features/book/presentation/widget/Book_card.dart';
import 'package:app/features/bookmark/notifier/notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LibraryBooks extends ConsumerStatefulWidget {
const LibraryBooks({super.key});

@override
ConsumerState<LibraryBooks> createState() => _LibraryBooksState();
}

class _LibraryBooksState extends ConsumerState<LibraryBooks> {
@override
void initState() {
  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) async {
    try {
      final List<String> bookIds = await ref.read(bookmarkNotifierProvider);
      print("go-go-go");
      print(bookIds);

      if (bookIds.isNotEmpty && mounted) {
        await ref
            .read(booksControllerProvider.notifier)
            .loadBooksFromIds(bookIds);
      }
    } catch (e) {
      debugPrint('Failed to initialize local library records: $e');
    }
  });
}

@override
Widget build(BuildContext context) {
  final state = ref.watch(booksControllerProvider);
  // Direct access to the list of books from the state controller
  final List<BookEntity> books = state.bookmarkBooks ?? [];
  final colors = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;

  if (state.bookmarkDataLoading) {
    return BookmarkLoadingList(colors: colors);
  }

  if (books.isEmpty) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Text(
          "No books available yet.",
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
        ),
      ),
    );
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        final isLast = index == books.length - 1;

        return BookCard(
          book: book,
          onTap: () =>
              moveTo(context, BookPage(bookId: book.uid), "book-${book.uid}"),
        );
      },
    ),
  );
}
}
