import 'package:app/features/book/presentation/provider/book_data_provider.dart';
import 'package:app/features/book/presentation/screen/book_screen.dart';
import 'package:app/features/book/presentation/widget/Book_hero.dart';
import 'package:app/features/home/presentation/widget/Collection_cover.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

class SingleCollectionPage extends ConsumerStatefulWidget {
  final String collectionId;
  final String coverUrl;
  final String description;
  final String title;
  final String? heroTag;

  const SingleCollectionPage({
    super.key,
    required this.collectionId,
    required this.coverUrl,
    required this.description,
    required this.title,
    this.heroTag,
  });

  @override
  ConsumerState<SingleCollectionPage> createState() => _SinglePageState();
}

class _SinglePageState extends ConsumerState<SingleCollectionPage> {
  final ScrollController _scrollController = ScrollController();

  static const double _expandedHeight = 380;
  static const double _titleRevealOffset = 260;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final state = ref.read(
        filterdBooksCollectionControllerProvider(widget.collectionId),
      );
      if (state.books.isEmpty) {
        ref
            .read(
              filterdBooksCollectionControllerProvider(
                widget.collectionId,
              ).notifier,
            )
            .loadFilterdBooks(
              collectionId: widget.collectionId,
              limit: 20,
              isRefresh: true,
            );
      }
    });
  }

  Widget _buildHeroBackground(String bookCover) {
    return AnimatedBuilder(
      animation: _scrollController,
      child: widget.heroTag != null
          ? Hero(
              tag: widget.heroTag!,
              child: CollectionCover(poster: bookCover),
            )
          : CollectionCover(poster: bookCover),
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
              colors: [Color(0xFF1C1917), Color(0xFF0A0908)],
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              SafeArea(
                child: Transform.scale(
                  scale: imageScale,
                  alignment: const AlignmentDirectional(0, -3),
                  child: Opacity(opacity: imageOpacity, child: child),
                ),
              ),
              // Scrim so back button + title stay legible over any cover
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 140,
                child: IgnorePointer(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black54, Colors.transparent],
                      ),
                    ),
                  ),
                ),
              ),
              // Fade to surface at the bottom, so the transition into
              // the scrollable content below feels seamless, not a hard cut
              Positioned(
                bottom: -2,
                left: 0,
                right: 0,
                height: 40,
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Theme.of(context).colorScheme.surface,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
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

        final showTitle = offset > _titleRevealOffset;

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

  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Material(
        color: Colors.black.withOpacity(0.35),
        shape: const CircleBorder(),
        child: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 18,
          ),
          splashRadius: 22,
        ),
      ),
    );
  }

  Widget _buildBooksSection(BuildContext context) {
    final bookState = ref.watch(
      filterdBooksCollectionControllerProvider(widget.collectionId),
    );

    final colors = Theme.of(context).colorScheme;

    if (bookState.isLoading && bookState.books.isEmpty) {
      return SizedBox(
        height: 220,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: 3,
          separatorBuilder: (_, __) => const SizedBox(width: 14),
          itemBuilder: (_, __) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 130,
                height: 170,
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 100,
                height: 12,
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (bookState.books.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        child: Center(
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.menu_book_outlined,
                  size: 28,
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "No books yet",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "We're still adding titles to this collection.\nCheck back soon.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          "Our Book's",
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSecondary,
            letterSpacing: 0.5,
            fontSize: 16,
            // fontWeight: FontWeight.w200,
          ),
        ),
        SizedBox(height: 10),
        
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
          itemCount: math.min(bookState.books.length, 6),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisExtent: 210,
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (context, index) {
            final book = bookState.books[index];

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
                          imageUrl: book.bookCover ?? "",
                          fit: BoxFit.fill,
                          placeholder: (_, __) =>
                              Container(color: colors.surfaceContainerHighest),
                          errorWidget: (_, __, ___) => Container(
                            color: colors.surfaceContainerHighest,
                            child: Icon(
                              Icons.menu_book_outlined,
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

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
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      extendBody: true,
      body: CustomScrollView(
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
                _buildBackButton(context),
                const SizedBox(width: 4),
                Expanded(child: _buildTitle(widget.title)),
              ],
            ),
            flexibleSpace: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(child: _buildHeroBackground(widget.coverUrl)),
              ],
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  Typography(
                    title: widget.title,
                    description: widget.description,
                  ),
                  _buildBooksSection(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Typography extends StatelessWidget {
  final String title;
  final String description;
  const Typography({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 6),
        Text(
          description,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontStyle: FontStyle.italic,
            fontSize: 15,
            wordSpacing: 2,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
