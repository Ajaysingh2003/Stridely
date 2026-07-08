import 'package:app/core/loader.dart';
import 'package:app/features/book/presentation/provider/book_data_provider.dart';
import 'package:app/features/book/presentation/screen/book_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

class BooksList extends ConsumerStatefulWidget {
  final String categoryId;
  final String title;
  const BooksList({super.key, required this.categoryId, required this.title});

  @override
  ConsumerState<BooksList> createState() => _BooksListWidgetState();
}

class _BooksListWidgetState extends ConsumerState<BooksList> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(filterdBooksControllerProvider(widget.categoryId).notifier)
          .loadFilterdBooks(categoryId: widget.categoryId, limit: 6, isRefresh: true);
    });
  }


  @override
  Widget build(BuildContext context) {
    final state = ref.watch(filterdBooksControllerProvider(widget.categoryId));
    final books = state.books;
    // final ssss=[...books,...books,...books,...books,...books,...books,...books];

    // ── ⏳ SKELETON SHIMMER LOADING ROW ──
    if (state.isLoading && books.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: const SkeletonBlock(width: 160, height: 22, borderRadius: 4),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 210, 
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(14),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Container(
                    width: 125,
                    margin: const EdgeInsets.only(right: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AspectRatio(
                          aspectRatio: 0.7,
                          child: SkeletonBlock(width: double.infinity, height: double.infinity, borderRadius: 12),
                        ),
                        const SizedBox(height: 8),
                        const SkeletonBlock(width: double.infinity, height: 12, borderRadius: 4),
                        const SizedBox(height: 4),
                        const SkeletonBlock(width: 60, height: 12, borderRadius: 4),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    if (books.isEmpty) return const SizedBox.shrink(); // Hide the container completely if empty

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 🎯 ROW HEADER ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                    letterSpacing: 0.5,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xff4A8FE8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text("View All", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios_rounded, size: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── 📜 HORIZONTAL SCROLLABLE LISTVIEW ──
          SizedBox(
            height: 210,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => BookPage(bookId: book.uid),
                        transitionDuration: const Duration(milliseconds: 550),
                        reverseTransitionDuration: const Duration(milliseconds: 500),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return SlideTransition(
                            position: Tween(begin: const Offset(1.5, 0.0), end: Offset.zero)
                                .animate(CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic)),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    width: 105, // Give every book layout box a clean fixed width profile
                    margin: const EdgeInsets.only(right: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🔒 Fixed Cover Aspect Ratio Wrapper
                        AspectRatio(
                          aspectRatio: 0.7,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white.withOpacity(0.12)),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: book.bookCover,
                                fit: BoxFit.cover, 
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // 📝 Title Segment
                        Text(
                          book.title ?? "",
                          maxLines: 2,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headlineSmall
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}