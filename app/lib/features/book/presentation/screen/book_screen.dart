import 'package:app/features/auth/domain/entities/user_entity.dart';
import 'package:app/features/auth/presentation/pages/login_screen.dart';
import 'package:app/features/book/domain/entity/book_entity.dart';
import 'package:app/features/auth/presentation/provider/auth_di_providers.dart';
import 'package:app/features/book/presentation/provider/book_data_provider.dart';
import 'package:app/features/book/presentation/screen/book_content_screen.dart';
import 'package:app/features/book/presentation/widget/Book_hero.dart';
import 'package:app/features/book/presentation/widget/book_details_skeleton.dart';
import 'package:app/features/book/presentation/widget/book_view.dart';
import 'package:app/features/book/utility/book_utilty.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookPage extends ConsumerStatefulWidget {
  final String title;

  const BookPage({super.key, this.title = "Rich Dad Poor Dad"});

  @override
  ConsumerState<BookPage> createState() => _BookPageState();
}

class _BookPageState extends ConsumerState<BookPage> {
  final ScrollController _scrollController = ScrollController();

  static const double _expandedHeight = 380;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildHeroBackground(String bookCover) {
    return AnimatedBuilder(
      animation: _scrollController,
      child: BookHero(bookCover: bookCover),
      builder: (context, child) {
        double offset = 0;

        if (_scrollController.hasClients) {
          offset = _scrollController.offset;
        }

        final progress = (offset / (_expandedHeight - kToolbarHeight)).clamp(
          0.0,
          1.0,
        );

        final imageScale = 1.0 - (progress * 0.45);

        final imageOpacity = (1.0 - (progress * 1.4)).clamp(0.0, 1.0);

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1A365D), Color(0xFF000000)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Transform.scale(
                scale: imageScale,
                alignment: AlignmentDirectional(0, -3),
                child: Opacity(opacity: imageOpacity, child: child),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle(String title) {
    return AnimatedBuilder(
      animation: _scrollController,
      builder: (context, _) {
        double offset = 0;

        if (_scrollController.hasClients) {
          offset = _scrollController.offset;
        }

        final showTitle = offset > 260;

        return AnimatedOpacity(
          opacity: showTitle ? 1 : 0,
          duration: const Duration(milliseconds: 200),
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: const Color.fromARGB(227, 255, 255, 255),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStartReadingButton(
    BuildContext context,
    BookEntity book,
    String contentId,
  )
   
  {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {},
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors
                .transparent, // 👈 The core middle channel remains completely transparent
            // borderRadius: BorderRadius.circular(24),
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                SizedBox(
                  width:
                      85, // Sized normally to hold the "Read" text comfortably
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(20),
                          right: Radius.circular(6),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if (book.isFree) {
                        // Navigator.push(
                        //   context,
                        //   PageRouteBuilder(
                        //     pageBuilder:
                        //         (context, animation, secondaryAnimation) =>
                        //             BookContentPage(contentId: contentId),
                        //     transitionDuration: const Duration(
                        //       milliseconds: 550,
                        //     ),
                        //     reverseTransitionDuration: const Duration(
                        //       milliseconds: 500,
                        //     ), // Speed when going back
                        //     transitionsBuilder:
                        //         (
                        //           context,
                        //           animation,
                        //           secondaryAnimation,
                        //           child,
                        //         ) {
                        //           // Slides from right (1.0, 0.0) to center (0.0, 0.0)

                        //           final begin = const Offset(1.5, 0.0);
                        //           final end = Offset.zero;
                        //           final tween = Tween(begin: begin, end: end);

                        //           // Makes the animation start fast and slow down gently (smooth look)
                        //           final curvedAnimation = CurvedAnimation(
                        //             parent: animation,

                        //             curve: Curves.easeInOutCubic,
                        //           );

                        //           return SlideTransition(
                        //             position: tween.animate(curvedAnimation),

                        //             child: child,
                        //           );
                        //         },
                        //   ),
                        // );



                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookContentPage(contentId: contentId),
                          ),
                        );

                        return;
                      }

                      final UserEntity? currentUser = await ref
                          .read(authControllerProvider.notifier)
                          .getCurrentUser();

                      final bool isPremiumUser =
                          currentUser?.isPremium ?? false;

                      if (book.canAccessAudio(isPremiumUser)) {
                        // Navigator.push(context, LoginPage());
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      } else {
                        // revenue cat
                      }
                      // print("Main reader flow triggered!");
                    },
                    child: Text(
                      "Read",
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                ),

                VerticalDivider(
                  width: 2,
                  thickness: 1,
                  indent: 1,
                  endIndent: 1,
                  color: Colors.transparent,
                ),

                SizedBox(
                  width: 54,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(20),
                          left: Radius.circular(6),
                        ),
                      ),
                    ),
                    onPressed: () => Navigator.maybePop(context),
                    child: Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: Theme.of(context).colorScheme.primary,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final bookId = "QPsnrnqHjaUm5ybN8YAt";
    final bookAsync = ref.watch(singleBookProvider(bookId));
    final contentsync = ref.watch(bookTitleControllerProvider(bookId)).titles;
    final firstContent = contentsync.isNotEmpty ? contentsync.first : null;
    // final firstContent=ref.read(bookTitleControllerProvider.)
    // final bookContentAsync = ref.watch(
    //   singleBookContentProvider("UK3Hi4dSdiq7kU5qME6R"),
    // );

    // print('🔥 RAW FIRESTORE DATA: $bookContentAsync');
    return Scaffold(
      backgroundColor: colors.surface,
      extendBody: true,
      // bottomNavigationBar: _buildBottomBar(context),
      body: bookAsync.when(
        data: (eitherResult) {
          return eitherResult.fold(
            (failure) => Center(
              child: Text('Backend Failure: ${failure.message.toString()}'),
            ),

            (book) => CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  pinned: true,
                  stretch: true,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  backgroundColor: const Color(0xFF0F172A),
                  expandedHeight: _expandedHeight,
                  toolbarHeight: 100,
                  automaticallyImplyLeading: false,

                  titleSpacing: 0,

                  title: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.maybePop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 21,
                        ),
                      ),

                      const SizedBox(width: 4),

                      Expanded(child: _buildTitle(book.title ?? "")),
                    ],
                  ),

                  flexibleSpace: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned.fill(
                        child: _buildHeroBackground(book.bookCover),
                      ),

                      Positioned(
                        bottom: -24,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Row(
                                  mainAxisSize: MainAxisSize
                                      .min, // Keeps the row tight around the buttons
                                  children: [
                                    // 1. BOOKMARK BUTTON
                                    IconButton(
                                      style: IconButton.styleFrom(
                                        fixedSize: const Size(48, 48),
                                        backgroundColor: colors.secondary,
                                        shape: const CircleBorder(),
                                        padding: EdgeInsets.zero,
                                      ),
                                      onPressed: () =>
                                          print("Bookmark clicked"),
                                      icon: Icon(
                                        Icons.bookmark_add_outlined,
                                        color: colors.onSecondary,
                                        size:
                                            24, // Balanced icon sizing for a 54px circle
                                      ),
                                    ),

                                    const SizedBox(
                                      width: 24,
                                    ), // Standardized spacing separation gutter
                                    // 2. SHARE BUTTON
                                    IconButton(
                                      style: IconButton.styleFrom(
                                        fixedSize: const Size(
                                          48,
                                          48,
                                        ), // 🚀 Forces an exactly identical container shape
                                        backgroundColor: colors.secondary,
                                        shape: const CircleBorder(),
                                        padding: EdgeInsets.zero,
                                      ),
                                      onPressed: () => print("Share clicked"),
                                      icon: Icon(
                                        Icons.ios_share_outlined,
                                        color: colors.onSecondary,
                                        size: 23,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _buildStartReadingButton(
                                context,
                                book,
                                firstContent?["uid"] ?? "",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 40)),

                SliverToBoxAdapter(
                  child: Container(
                    color: colors.surface,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [BookView(book: book)],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        error: (error, stackTrace) =>
            Center(child: Text('System Error occurred: $error')),
        loading: () => const Center(child: BookDetailSkeleton()),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      height: 95,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.1)),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.menu_book_rounded, color: Colors.white),
              label: const Text(
                "Read",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color.fromARGB(255, 49, 49, 49),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.headset_rounded, color: Colors.white),
                label: const Text(
                  "Listen",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color(0xFF3B7BFB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
