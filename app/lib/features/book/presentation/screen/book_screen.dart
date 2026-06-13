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

  static const double _expandedHeight = 380;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildHeroBackground() {
    return AnimatedBuilder(
      animation: _scrollController,
      child: const BookHero(),
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
                alignment: AlignmentDirectional(0, -5),
                child: Opacity(opacity: imageOpacity, child: child),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
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
            widget.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        );
      },
    );
  }

  Widget _buildStartReadingButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {},
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: const Color(0xFF3B7BFB),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.play_arrow_rounded, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                "Start Reading",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
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

    return Scaffold(
      backgroundColor: colors.surface,
      extendBody: true,
      // bottomNavigationBar: _buildBottomBar(context),
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
            toolbarHeight: 90,
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

                Expanded(child: _buildTitle()),
              ],
            ),

            // actions: [
            //   IconButton(
            //     onPressed: () {},
            //     icon: const Icon(Icons.bookmark_add, color: Colors.white70),
            //   ),
            //   IconButton(
            //     onPressed: () {},
            //     icon: const Icon(Icons.ios_share, color: Colors.white70),
            //   ),
            //   IconButton(
            //     onPressed: () {},
            //     icon: const Icon(
            //       Icons.file_download_outlined,
            //       color: Colors.white70,
            //     ),
            //   ),
            // ],

            flexibleSpace: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(child: _buildHeroBackground()),

                Positioned(
                  bottom: -24,
                  left: 0,
                  right: 0,
                  child: Center(
                    child:  _buildStartReadingButton(),
                  ),
                ),
              ],
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),

          SliverToBoxAdapter(
            child: Container(
              color: colors.surface,
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



