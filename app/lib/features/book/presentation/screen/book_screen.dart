import 'package:app/features/book/domain/entity/book_entity.dart';
import 'package:app/features/book/presentation/screen/book_content_screen.dart';
import 'package:app/features/book/presentation/widget/Book_hero.dart';
import 'package:app/features/book/presentation/widget/book_details_skeleton.dart';
import 'package:app/features/book/presentation/widget/book_view.dart';
import 'package:app/features/book/presentation/provider/book_data_provider.dart';
import 'package:app/features/bookmark/notifier/notifier.dart';
import 'package:app/features/shared/share.dart';
import 'package:app/features/subscriptions/providers/subscription_provider.dart';
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
            child: Transform.scale(
              scale: imageScale,
              alignment: const AlignmentDirectional(0, -3),
              child: Opacity(opacity: imageOpacity, child: child),
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
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w700,
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
    bool isPremiumUser,
  ) {
    final theme = Theme.of(context);
    final hasAccess = book.isFree || isPremiumUser;

    return Material(
      color: Colors.transparent,
      child: Container(
        height: 48,
        decoration: const BoxDecoration(color: Colors.transparent),
        child: hasAccess
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(20),
                            right: Radius.circular(6),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BookContentPage(contentId: contentId),
                          ),
                        );
                      },
                      child: Text(
                        "Read",
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 2),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(20),
                            left: Radius.circular(6),
                          ),
                        ),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookContentPage(
                            contentId: contentId,
                            openAudio: true,
                          ),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: theme.colorScheme.primary,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF212121),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () async {
                  final PaywallResult result =
                      await RevenueCatUI.presentPaywall(
                        displayCloseButton: true,
                      );

                  if ((result == PaywallResult.purchased ||
                          result == PaywallResult.restored) &&
                      context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BookContentPage(contentId: contentId),
                      ),
                    );
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.lock_outline_rounded,
                      size: 16,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Unlock Book',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.1,
                      ),
                    ),
                  ],
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
    final contentSync = ref.watch(bookTitleControllerProvider(bookId)).titles;
    final firstContent = contentSync.isNotEmpty ? contentSync.first : null;
    final isPremium = ref.watch(isPremiumProvider);

    
    
    return Scaffold(
      backgroundColor: colors.surface,
      extendBody: true,
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
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 20,
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
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    style: IconButton.styleFrom(
                                      fixedSize: const Size(48, 48),
                                      backgroundColor: colors.secondary,
                                      shape: const CircleBorder(),
                                      padding: EdgeInsets.zero,
                                    ),
                                    onPressed: () {
                                      ref
                                          .read(
                                            bookmarkNotifierProvider.notifier,
                                          )
                                          .toggle(widget.bookId);
                                    },
                                    icon: Icon(
                                      ref
                                              .watch(bookmarkNotifierProvider)
                                              .contains(widget.bookId)
                                          ? Icons.bookmark_added_rounded
                                          : Icons.bookmark_border_rounded,
                                      color: colors.onSecondary,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  IconButton(
                                    style: IconButton.styleFrom(
                                      fixedSize: const Size(48, 48),
                                      backgroundColor: colors.secondary,
                                      shape: const CircleBorder(),
                                      padding: EdgeInsets.zero,
                                    ),
                                    onPressed: () async {
                                      await BookSharer.shareBookWithImage(
                                        title: book.title ?? "",
                                        imageUrl: book.bookCover,
                                      );
                                    },
                                    icon: Icon(
                                      Icons.ios_share_outlined,
                                      color: colors.onSecondary,
                                      size: 21,
                                    ),
                                  ),
                                ],
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
}
