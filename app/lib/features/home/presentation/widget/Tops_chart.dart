// import 'package:app/core/loader.dart';
// import 'package:app/features/book/presentation/provider/book_data_provider.dart';
// import 'package:app/features/book/presentation/screen/book_screen.dart';
// import 'package:app/features/home/presentation/pages/Category_pages.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class BooksList extends ConsumerStatefulWidget {
//   final String categoryId;
//   final String title;
//   const BooksList({super.key, required this.categoryId, required this.title});

//   @override
//   ConsumerState<BooksList> createState() => _BooksListWidgetState();
// }

// class _BooksListWidgetState extends ConsumerState<BooksList> {
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       ref
//           .read(filterdBooksControllerProvider(widget.categoryId).notifier)
//           .loadFilterdBooks(
//             categoryId: widget.categoryId,
//             limit: 6,
//             isRefresh: true,
//           );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(filterdBooksControllerProvider(widget.categoryId));
//     final books = state.books;

//     if (state.isLoading && books.isEmpty) {
//       return Container(
//         padding: const EdgeInsets.symmetric(vertical: 14),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 14),
//               child: const SkeletonBlock(
//                 width: 160,
//                 height: 22,
//                 borderRadius: 4,
//               ),
//             ),
//             const SizedBox(height: 16),
//             SizedBox(
//               height: 210,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 padding: const EdgeInsets.all(14),
//                 itemCount: 4,
//                 itemBuilder: (context, index) {
//                   return Container(
//                     width: 125,
//                     margin: const EdgeInsets.only(right: 14),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const AspectRatio(
//                           aspectRatio: 0.7,
//                           child: SkeletonBlock(
//                             width: double.infinity,
//                             height: double.infinity,
//                             borderRadius: 12,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         const SkeletonBlock(
//                           width: double.infinity,
//                           height: 12,
//                           borderRadius: 4,
//                         ),
//                         const SizedBox(height: 4),
//                         const SkeletonBlock(
//                           width: 60,
//                           height: 12,
//                           borderRadius: 4,
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     if (books.isEmpty) return const SizedBox.shrink();

//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 14),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ── 🎯 ROW HEADER ──
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 14),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   widget.title,
//                   style: Theme.of(context).textTheme.labelMedium?.copyWith(
//                     color: Theme.of(context).colorScheme.onSecondary,
//                     letterSpacing: 0.5,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       PageRouteBuilder(
//                         settings: RouteSettings(
//                           name: 'category${widget.categoryId}',
//                         ),
//                         transitionDuration: const Duration(milliseconds: 400),
//                         reverseTransitionDuration: const Duration(
//                           milliseconds: 350,
//                         ),
//                         pageBuilder: (_, animation, __) => FadeTransition(
//                           opacity: animation,
//                           child: CategoryPages(
//                             title: widget.title,
//                             coverUrl:
//                                 "https://pub-d0026e62fb874713bb7e643ae55b5e34.r2.dev/ChatGPT%20Image%20Jul%2012%2C%202026%20at%2010_00_08%20PM.png",
//                             categoryId: widget.categoryId,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                   style: TextButton.styleFrom(
//                     foregroundColor: const Color(0xff4A8FE8),
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 4,
//                     ),
//                     minimumSize: Size.zero,
//                     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: const [
//                       Text(
//                         "View All",
//                         style: TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       SizedBox(width: 4),
//                       Icon(Icons.arrow_forward_ios_rounded, size: 10),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 12),

//           // ── 📜 HORIZONTAL SCROLLABLE LISTVIEW ──
//           SizedBox(
//             height: 210,
//             child: ListView.builder(
//               shrinkWrap: true,
//               physics: const BouncingScrollPhysics(),
//               scrollDirection: Axis.horizontal,
//               padding: const EdgeInsets.symmetric(horizontal: 14),
//               itemCount: books.length,
//               itemBuilder: (context, index) {
//                 final book = books[index];

//                 return GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       PageRouteBuilder(
//                         pageBuilder: (context, animation, secondaryAnimation) =>
//                             BookPage(bookId: book.uid),
//                         transitionDuration: const Duration(milliseconds: 550),
//                         reverseTransitionDuration: const Duration(
//                           milliseconds: 500,
//                         ),
//                         transitionsBuilder:
//                             (context, animation, secondaryAnimation, child) {
//                               return SlideTransition(
//                                 position:
//                                     Tween(
//                                       begin: const Offset(1.5, 0.0),
//                                       end: Offset.zero,
//                                     ).animate(
//                                       CurvedAnimation(
//                                         parent: animation,
//                                         curve: Curves.easeInOutCubic,
//                                       ),
//                                     ),
//                                 child: child,
//                               );
//                             },
//                       ),
//                     );
//                   },
//                   child: Container(
//                     width:
//                         105, 
//                     margin: const EdgeInsets.only(right: 14),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // 🔒 Fixed Cover Aspect Ratio Wrapper
//                         AspectRatio(
//                           aspectRatio: 0.7,
//                           child: Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               border: Border.all(
//                                 color: Colors.white.withOpacity(0.12),
//                               ),
//                             ),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(10),
//                               child: CachedNetworkImage(
//                                 imageUrl: book.bookCover,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 8),

//                         // 📝 Title Segment
//                         Text(
//                           book.title ?? "",
//                           maxLines: 2,
//                           textAlign: TextAlign.left,
//                           overflow: TextOverflow.ellipsis,
//                           style: Theme.of(context).textTheme.headlineSmall,
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:app/core/loader.dart';
import 'package:app/features/book/presentation/provider/book_data_provider.dart';
import 'package:app/features/book/presentation/screen/book_screen.dart';
import 'package:app/features/home/presentation/pages/Category_pages.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(filterdBooksControllerProvider(widget.categoryId).notifier)
           .loadFilterdBooks(categoryId: widget.categoryId, limit: 6, isRefresh: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(filterdBooksControllerProvider(widget.categoryId));
    final books = state.books;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      // Use mainAxisSize: MainAxisSize.min to prevent vertical expansion
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 12),
          SizedBox(
            height: 210, // Consistent fixed height
            child: state.isLoading && books.isEmpty 
                ? _buildLoadingList() 
                : _buildBookList(books),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSecondary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () => _navigateToCategory(context),
            child: const Row(
              children: [
                Text("View All", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios_rounded, size: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      itemCount: 4,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, __) => Container(
        width: 105,
        margin: const EdgeInsets.only(right: 14),
        child: Column(
          children: [
            const AspectRatio(aspectRatio: 0.7, child: SkeletonBlock(width: double.infinity, height: double.infinity, borderRadius: 10)),
            const SizedBox(height: 8),
            const SkeletonBlock(width: 80, height: 12, borderRadius: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildBookList(List<dynamic> books) {
    if (books.isEmpty) return const SizedBox.shrink();

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      physics: const BouncingScrollPhysics(),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return GestureDetector(
          onTap: () => Navigator.push(context, _buildBookPageRoute(book.uid)),
          child: Container(
            width: 105,
            margin: const EdgeInsets.only(right: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 0.7,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(imageUrl: book.bookCover, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  book.title ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper methods to keep build clean
  void _navigateToCategory(BuildContext context) {
    Navigator.push(context, PageRouteBuilder(
      pageBuilder: (_, __, ___) => CategoryPages(
        title: widget.title,
        coverUrl: "...",
        categoryId: widget.categoryId,
      ),
    ));
  }

  PageRouteBuilder _buildBookPageRoute(String bookId) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => BookPage(bookId: bookId),
      transitionsBuilder: (_, anim, __, child) => SlideTransition(
        position: Tween(begin: const Offset(1.5, 0), end: Offset.zero).animate(anim),
        child: child,
      ),
    );
  }
}