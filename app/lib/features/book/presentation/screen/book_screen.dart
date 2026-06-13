import 'package:app/features/book/presentation/widget/Book_hero.dart';
import 'package:app/features/book/presentation/widget/book_view.dart';
import 'package:flutter/material.dart';

class BookPage extends StatefulWidget {
  final String title;
  const BookPage({super.key, this.title = "Rich Dad Poor Dad"});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  final ScrollController _scrollController = ScrollController();
  static const double _expandedHeight = 400.0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _buildHeroBackground() {
    print(_scrollController);
    print("check-3");

    return AnimatedBuilder(
      animation: _scrollController, // listens directly to scroll
      builder: (context, child) {
        // ✅ Compute values here — only this widget rebuilds, not BookPage
        double scrollOffset = 0.0;
        if (_scrollController.hasClients) {
          scrollOffset = _scrollController.offset;
        }

        final double scrollProgress =
            (scrollOffset / (_expandedHeight - kToolbarHeight)).clamp(0.0, 1.0);
        final double imageScale = 1.0 - (scrollProgress * 0.5);
        final double imageOpacity = (1.0 - scrollProgress * 1.4).clamp(
          0.0,
          1.0,
        );
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
              padding: const EdgeInsets.only(top: 56.0),
              child: LayoutBuilder(
                builder: (context, constraints) => Transform.scale(
                  scale: imageScale,
                  alignment: Alignment.topCenter,
                  child: Opacity(
                    opacity: imageOpacity,
                    child: SizedBox(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      child: child, // ✅ child is cached, not rebuilt
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      // ✅ BookHero is built once and passed as cached child
      child: const BookHero(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).colorScheme;

    return Scaffold(
      extendBody: true,
      backgroundColor: themeColors.surface,
      bottomNavigationBar: _buildBottomBar(context),
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverAppBar(
            expandedHeight: _expandedHeight,
            collapsedHeight: 90,
            pinned: true,
            elevation: 50,
            scrolledUnderElevation: 100,
            backgroundColor: const Color(0xFF0F172A),
            automaticallyImplyLeading: false,
            stretch: true,
            titleSpacing: 0,
            title: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
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
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _scrollController,
                      builder: (context, _) {
                        double offset = 0.0;

                        if (_scrollController.hasClients) {
                          offset = _scrollController.offset;
                        }
                        final bool showTitle = offset > 300;

                        return AnimatedSlide(offset: showTitle ? Offset.zero : const Offset(0, 0.8),
                         duration: const Duration(milliseconds: 350),curve: Curves.easeOutCubic,child: AnimatedOpacity(
                          opacity: showTitle ? 1.0 : 0.0,
                          duration: const Duration(microseconds: 500),
                          child: Text(
                            widget.title,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: const Color.fromARGB(205, 255, 255, 255)
                            ),
                          ),
                        ),);
                      },
                    ),
                  ),
                ],
              ),
            ),
            // actions: [
            //   IconButton(
            //     onPressed: () {},
            //     icon: const Icon(
            //       Icons.bookmark_add,
            //       color: Colors.white70,
            //       size: 23,
            //     ),
            //   ),
            //   IconButton(
            //     onPressed: () {},
            //     icon: const Icon(
            //       Icons.ios_share,
            //       color: Colors.white70,
            //       size: 23,
            //     ),
            //   ),
            //   Padding(
            //     padding: const EdgeInsets.only(right: 12),
            //     child: IconButton(
            //       onPressed: () {},
            //       icon: const Icon(
            //         Icons.file_download_outlined,
            //         color: Colors.white70,
            //         size: 26,
            //       ),
            //     ),
            //   ),
            // ],
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeroBackground(),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              color: themeColors.surface,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [BookView()],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      height: 95,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(0, 25, 23, 23),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(150),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            height: 52,
            width: 130,
            child: ElevatedButton.icon(
              onPressed: () => print("Navigate to Reader Screen"),
              icon: const Icon(
                Icons.format_align_left_sharp,
                color: Colors.white,
                size: 20,
              ),
              label: const Text(
                "Read",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 49, 49, 49),
                elevation: 0,
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
              child: OutlinedButton.icon(
                onPressed: () => print("Open Audio Player UI"),
                icon: const Icon(
                  Icons.headset_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                label: Text(
                  "Listen",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color(0xFF3B7BFB),
                  side: BorderSide.none,
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
