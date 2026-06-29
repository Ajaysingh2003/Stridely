import 'package:app/features/book/domain/entity/book_entity.dart';
import 'package:app/features/book/presentation/provider/book_data_provider.dart';
import 'package:app/features/book/presentation/widget/Book_about.dart';
import 'package:app/features/book/presentation/widget/Excerpt.dart';
import 'package:app/features/book/presentation/widget/key_points.dart';
import 'package:app/features/book/presentation/widget/what_you_learn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookTab extends ConsumerStatefulWidget {
  final BookEntity book;
  const BookTab({super.key, required this.book});

  @override
  ConsumerState<BookTab> createState() => _BookTabState();
}

class _BookTabState extends ConsumerState<BookTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;
  final String bookId = "QPsnrnqHjaUm5ybN8YAt";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _currentTabIndex = _tabController.index;
        });
      }
    });

    // 🚀 STEP 1: Safely trigger your asynchronous setup logic on widget initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bookTitleControllerProvider(bookId).notifier).loadBookTitles(bookId);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) { // 🎉 Kept cleanly synchronous
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final String aboutStr = widget.book.aboutBook ?? "";
    final String forWhomStr = widget.book.forWhom ?? "";
    final AuthorType authorData = AuthorType(
      name: widget.book.author.name,
      bio: widget.book.author.bio,
    );

    final updatedState = ref.watch(bookTitleControllerProvider(bookId));
    print('🎯 Fresh titles data length: ${updatedState.titles}');
    print('⚠️ Any error message? ${updatedState.errorMessage}');

    // final List<KeyPoint> contents = [
    //   KeyPoint(id: "kp1", text: "First key concept overview data markerssss."),
    //   KeyPoint(id: "kp2", text: "Crucial strategic performance variable milestone."),
    //   KeyPoint(id: "kp3", text: "Final data summary calculation metric context."),
    // ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.12),
                width: 1,
              ),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelPadding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            physics: const BouncingScrollPhysics(),
            indicatorSize: TabBarIndicatorSize.label,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(width: 2.5, color: colorScheme.primary),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
            ),
            labelColor: colorScheme.primary,
            unselectedLabelColor: colorScheme.onSurface.withValues(alpha: 0.5),
            labelStyle: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 0.1,
            ),
            unselectedLabelStyle: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.1,
            ),
            splashFactory: NoSplash.splashFactory,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            tabs: const [
              Tab(text: "About"),
              Tab(text: "Outline"),
              Tab(text: "Key learning"),
              Tab(text: "Excerpt"),
            ],
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 16),
            child: _buildActiveTabContent(
              index: _currentTabIndex,
              aboutStr: aboutStr,
              forWhomStr: forWhomStr,
              authorData: authorData,
              contents: updatedState.titles,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveTabContent({
    required int index,
    required String aboutStr,
    required String forWhomStr,
    required AuthorType authorData,
    required List<Map<String, String>> contents,

    // required List<KeyPoint> contents,
  }) {
    switch (index) {
      case 0:
        return BookAbout(
          about: aboutStr,
          forWhom: forWhomStr,
          author: authorData,
        );
      case 1:
        return KeyPoints(points: contents);
      case 2:
        return Learning(learning: widget.book.whatsInside);
      case 3:
        return Excerpt(excerpt: widget.book.quotes);
      default:
        return const SizedBox.shrink();
    }
  }
}