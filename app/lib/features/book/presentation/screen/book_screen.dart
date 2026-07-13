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
import 'package:app/features/subscriptions/providers/subscription_provider.dart';
import 'package:app/features/subscriptions/service/init.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_ui_flutter/paywall_result.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

class BookPage extends ConsumerStatefulWidget {
  final String bookId;

  const BookPage({super.key, required this.bookId});

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
    bool showReadButton,
  ) {
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
            child:true
            //  showReadButton || book.isFree
                ? Row(
                    children: [
                      SizedBox(
                        width:
                            85, // Sized normally to hold the "Read" text comfortably
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
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
                            print('isFree chiku ${book.isFree}');
                            // 1. 🆓 FREE CHECK: If the book is free, open it instantly
                            if (book.isFree) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BookContentPage(contentId: contentId),
                                ),
                              );
                              return;
                            }

                            // 2. 🛡️ PREMIUM CHECK: If it's a paid book, check if they are already Premium
                            final isPremium = await RevenueCatService.instance
                                .isUserPremium();

                            if (isPremium) {
                              // Already premium? Skip the paywall entirely!
                              if (context.mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BookContentPage(contentId: contentId),
                                  ),
                                );
                              }
                              return;
                            }

                            // 3. 💳 PAYWALL TRIGGER: Not premium? Pop up your RevenueCat UI sheet
                            if (context.mounted) {
                              final PaywallResult result =
                                  // await RevenueCatUI.presentPaywall(
                                  //   displayCloseButton: true,
                                  // );
                                  await RevenueCatUI.presentPaywall(
                                    displayCloseButton: true,
                                  );

                              // 4. 🎯 HANDLE THE PAYWALL RESULT:
                              if (result == PaywallResult.purchased ||
                                  result == PaywallResult.restored) {
                                print("🎉 Access Granted! Let them read.");

                                if (context.mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BookContentPage(contentId: contentId),
                                    ),
                                  );
                                }
                              } else {
                                print("❌ Purchase cancelled or failed.");
                                // The paywall closes automatically, leaving them on the current screen.
                              }
                            }
                          },
                          child: Text(
                            "Read",
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
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
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
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
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ref.watch(isPremiumProvider)
                          ? Theme.of(context).colorScheme.primary
                          : const Color(0xFF212121),
                      foregroundColor: Colors.white,
                      // padding: const EdgeInsets.symmetric(
                      //   horizontal: 24,
                      //   vertical: 14,
                      // ),
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(12),
                      // ),
                    ),
                    onPressed: () async {
                      final isPremiumUser = ref.read(isPremiumProvider);

                      if (!isPremiumUser) {


                        await RevenueCatUI.presentPaywall(
                          displayCloseButton: true,
                        );
                      } 
                      
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.lock_outline_rounded,
                          size: 18,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Unlock',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final bookId = widget.bookId;
    final bookAsync = ref.watch(singleBookProvider(bookId));
    final contentsync = ref.watch(bookTitleControllerProvider(bookId)).titles;
    final firstContent = contentsync.isNotEmpty ? contentsync.first : null;

    // final streamUserInfo=ref.watch(subscriptionStreamProvider)
    final isPremium = ref.watch(isPremiumProvider);
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
                                isPremium,
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
