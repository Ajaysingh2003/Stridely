import 'package:app/features/book/presentation/widget/Book_hero.dart';
import 'package:app/features/book/presentation/widget/book_view.dart';
import 'package:flutter/material.dart';

// ── Custom delegate — you own every pixel ──
class _BookHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final String title;
  final ScrollController scrollController;
  final Widget heroChild;

  const _BookHeaderDelegate({
    required this.expandedHeight,
    required this.title,
    required this.scrollController,
    required this.heroChild,
  });

  @override
  double get minExtent => kToolbarHeight + 40; // collapsed height

  @override
  double get maxExtent => expandedHeight;

  @override
  bool shouldRebuild(_BookHeaderDelegate old) =>
      old.expandedHeight != expandedHeight || old.title != title;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double scrollProgress =
        (shrinkOffset / (expandedHeight - minExtent)).clamp(0.0, 1.0);
    final double imageScale = 1.0 - (scrollProgress * 0.5);
    final double imageOpacity = (1.0 - scrollProgress * 1.4).clamp(0.0, 1.0);
    final bool showTitle = scrollProgress > 0.75;

    return Stack(
      clipBehavior: Clip.none, // ✅ This actually works here
      children: [
        // ── Background gradient ──
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1A365D), Color(0xFF000000)],
              ),
            ),
          ),
        ),

        // ── Scaled + fading hero ──
        Positioned.fill(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 56.0),
              child: Transform.scale(
                scale: imageScale,
                alignment: Alignment.topCenter,
                child: Opacity(
                  opacity: imageOpacity,
                  child: heroChild,
                ),
              ),
            ),
          ),
        ),

        // ── AppBar row (back button + title) ──
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: SizedBox(
              height: kToolbarHeight,
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
                    child: AnimatedSlide(
                      offset: showTitle
                          ? Offset.zero
                          : const Offset(0, 0.8),
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOutCubic,
                      child: AnimatedOpacity(
                        opacity: showTitle ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 350),
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xD2FFFFFF),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.bookmark_add,
                        color: Colors.white70, size: 23),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.ios_share,
                        color: Colors.white70, size: 23),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.file_download_outlined,
                          color: Colors.white70, size: 26),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ✅ Button at bottom — bleeds OUTSIDE via Clip.none
        Positioned(
          bottom: -26, // half of 52px button height
          left: 20,
          right: 20,
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => print("Read"),
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D2D2D),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(80),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.menu_book_rounded,
                            color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text(
                          "Read",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => print("Listen"),
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B7BFB),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3B7BFB).withAlpha(100),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.headset_rounded,
                            color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text(
                          "Listen",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Main page ──
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
          // ✅ SliverPersistentHeader instead of SliverAppBar
          SliverPersistentHeader(
            pinned: true,
            delegate: _BookHeaderDelegate(
              expandedHeight: _expandedHeight,
              title: widget.title,
              scrollController: _scrollController,
              heroChild: const BookHero(),
            ),
          ),

          // ✅ top padding = button bleed (26) + breathing room (20)
          SliverToBoxAdapter(
            child: Container(
              color: themeColors.surface,
              padding: const EdgeInsets.fromLTRB(20, 46, 20, 120),
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
              icon: const Icon(Icons.format_align_left_sharp,
                  color: Colors.white, size: 20),
              label: const Text("Read",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 49, 49, 49),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () => print("Open Audio Player UI"),
                icon: const Icon(Icons.headset_rounded,
                    color: Colors.white, size: 20),
                label: Text("Listen",
                    style:
                        Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                            )),
                style: OutlinedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color(0xFF3B7BFB),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}