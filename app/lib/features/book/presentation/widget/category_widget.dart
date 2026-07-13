import 'package:app/core/loader.dart';
import 'package:app/features/book/presentation/provider/book_data_provider.dart';
import 'package:app/features/book/presentation/screen/book_screen.dart';
import 'package:app/features/home/presentation/pages/category_pages.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

class CategoryWidget extends ConsumerStatefulWidget {
  final String categoryId;
  final String title;
  const CategoryWidget({
    super.key,
    required this.categoryId,
    required this.title,
  });

  @override
  ConsumerState<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends ConsumerState<CategoryWidget> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(filterdBooksControllerProvider(widget.categoryId).notifier)
          .loadFilterdBooks(
            categoryId: widget.categoryId,
            limit: 6,
            isRefresh: true,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(filterdBooksControllerProvider(widget.categoryId));
    final books = state.books;

    if (state.isLoading && books.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shimmer row header placeholder block
            const SkeletonBlock(width: 140, height: 20, borderRadius: 4),
            const SizedBox(height: 16),

            // 3-Column Loading Grid Mirror
            GridView.builder(
              shrinkWrap: true,

              physics: const NeverScrollableScrollPhysics(),
              itemCount:
                  6, // Renders a perfect 2-row layout mask skeleton frame
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                // mainAxisExtent:220,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
                childAspectRatio: 0.55,
              ),
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Book Cover Aspect Ratio Box Frame
                    const AspectRatio(
                      aspectRatio: 0.72,
                      child: SkeletonBlock(
                        width: double.infinity,
                        height: double.infinity,
                        borderRadius: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Title Text Row 1
                    const SkeletonBlock(
                      width: double.infinity,
                      height: 12,
                      borderRadius: 4,
                    ),
                    const SizedBox(height: 4),
                    // Title Text Row 2 (Shorter)
                    const SkeletonBlock(width: 60, height: 12, borderRadius: 4),
                  ],
                );
              },
            ),
          ],
        ),
      );
    }

    if (books.isEmpty) {
      return SizedBox();
    }

    return Container(
      padding: EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title, // Fixed typo "Arivals" -> "Arrivals"
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  
                  color: Theme.of(context).colorScheme.onSecondary,
                  letterSpacing: 0.5,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // ── 🎯 MODERN TEXT ACTION STYLE ──
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      settings: RouteSettings(
                        name: 'category${widget.categoryId}',
                      ),
                      transitionDuration: const Duration(milliseconds: 400),
                      reverseTransitionDuration: const Duration(
                        milliseconds: 350,
                      ),
                      pageBuilder: (_, animation, __) => FadeTransition(
                        opacity: animation,
                        child: CategoryPages(
                          title: widget.title,
                          coverUrl: "https://pub-d0026e62fb874713bb7e643ae55b5e34.r2.dev/ChatGPT%20Image%20Jul%2012%2C%202026%20at%2010_00_08%20PM.png",
                          categoryId: widget.categoryId,
                        ),
                      ),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: const Color(
                    0xff4A8FE8,
                  ), // Accent blue matching your brand
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      "View All",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios_rounded, size: 10),
                  ],
                ),
              ),
            ],
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
            itemCount: math.min(books.length, 6),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisExtent: 210,
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, index) {
              final book = books[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          BookPage(bookId: book.uid),
                      transitionDuration: const Duration(milliseconds: 550),
                      reverseTransitionDuration: const Duration(
                        milliseconds: 500,
                      ),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            final begin = const Offset(1.5, 0.0);
                            final end = Offset.zero;
                            final tween = Tween(begin: begin, end: end);
                            final curvedAnimation = CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeInOutCubic,
                            );
                            return SlideTransition(
                              position: tween.animate(curvedAnimation),
                              child: child,
                            );
                          },
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Container(
                        height: 160,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0),
                          borderRadius: BorderRadius.circular(12),
                          // borderRadius:BorderRadius.circular(radius),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.12),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: book.bookCover,
                            fit: BoxFit
                                .fill, // ◄ Corrected syntax: Boxfit.cover -> BoxFit.cover
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // 📝 Title Label
                    Text(
                      book.title ?? "",
                      maxLines: 2,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
