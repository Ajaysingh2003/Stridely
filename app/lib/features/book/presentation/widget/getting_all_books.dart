import 'package:app/features/book/presentation/provider/book_data_provider.dart';
import 'package:app/features/book/presentation/screen/book_screen.dart';
import 'package:app/features/book/presentation/widget/Book_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookListView extends ConsumerStatefulWidget {
  /// Set true when this widget is placed inside another scrollable
  /// (e.g. a home page Column/SingleChildScrollView). When true, this
  /// list sizes itself to its content and automatically listens to
  /// whichever ancestor Scrollable it's embedded in — no need to pass
  /// a controller manually.
  final bool embedded;

  const BookListView({super.key, this.embedded = false});

  @override
  ConsumerState<BookListView> createState() => _BookListViewState();
}

class _BookListViewState extends ConsumerState<BookListView> {
  ScrollController? _ownScrollController;
  ScrollPosition? _attachedAncestorPosition;

  static const double _paginationThreshold = 200;

  @override
  void initState() {
    super.initState();

    if (!widget.embedded) {
      _ownScrollController = ScrollController()..addListener(_onScroll);
    }

    Future.microtask(() {
      final state = ref.read(allBooksControllerProvider);
      if (state.books.isEmpty && !state.isLoading) {
        ref
            .read(allBooksControllerProvider.notifier)
            .loadFilterdBooks(isRefresh: true);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!widget.embedded) return;

    // Find the nearest ancestor Scrollable (whatever HomePage uses —
    // SingleChildScrollView, CustomScrollView, etc.) and listen to its
    // position directly. No controller needs to be passed in for this.
    final ancestorState = Scrollable.maybeOf(context);
    final newPosition = ancestorState?.position;

    if (newPosition == _attachedAncestorPosition) return;

    _attachedAncestorPosition?.removeListener(_onScroll);
    _attachedAncestorPosition = newPosition;
    _attachedAncestorPosition?.addListener(_onScroll);
  }

  @override
  void dispose() {
    _ownScrollController?.removeListener(_onScroll);
    _ownScrollController?.dispose();
    _attachedAncestorPosition?.removeListener(_onScroll);
    super.dispose();
  }
  // Add this variable to _BookListViewState
  // bool _isFetching = false;

  void _onScroll() {
    final position = widget.embedded
        ? _attachedAncestorPosition
        : _ownScrollController?.position;

    if (position == null || !position.hasContentDimensions) return;

    // 1. Check if we are near bottom
    final nearBottom =
        position.pixels >= position.maxScrollExtent - _paginationThreshold;

    // 2. Only fetch if we are actually at the bottom AND not currently loading
    final state = ref.read(allBooksControllerProvider);
    if (nearBottom && !state.isLoading && state.hasMore) {
      // This will now only trigger once per loading cycle
      ref.read(allBooksControllerProvider.notifier).loadFilterdBooks();
    }
  }

  Future<void> _onRefresh() async {
    await ref
        .read(allBooksControllerProvider.notifier)
        .loadFilterdBooks(isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(allBooksControllerProvider);
    final colors = Theme.of(context).colorScheme;

    if (state.isLoading && state.books.isEmpty) {
      return ListView.builder(
        shrinkWrap: widget.embedded,
        physics: widget.embedded
            ? const NeverScrollableScrollPhysics()
            : const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(14),
        itemCount: 6,
        itemBuilder: (_, __) => const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: _BookCardSkeleton(),
        ),
      );
    }

    if (state.errorMessage != null && state.books.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: colors.error, size: 32),
            const SizedBox(height: 12),
            Text(
              "Couldn't load books",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              state.errorMessage!,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => ref
                  .read(allBooksControllerProvider.notifier)
                  .loadFilterdBooks(isRefresh: true),
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    if (state.books.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Text(
            "No books available yet.",
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
          ),
        ),
      );
    }

    final list = ListView.builder(
      controller: widget.embedded ? null : _ownScrollController,
      shrinkWrap: widget.embedded,
      physics: widget.embedded
          ? const NeverScrollableScrollPhysics()
          : const AlwaysScrollableScrollPhysics(),
      // padding: const EdgeInsets.all(16),
      addAutomaticKeepAlives: false,
      itemCount: state.books.length + (state.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.books.length) {
          if (state.errorMessage != null) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: TextButton(
                  onPressed: () => ref
                      .read(allBooksControllerProvider.notifier)
                      .loadFilterdBooks(),
                  child: const Text("Tap to retry"),
                ),
              ),
            );
          }
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        final book = state.books[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _RevealOnBuild(
            key: ValueKey(book.uid),
            child: BookCard(book: book,onTap: () =>  Navigator.push(
                    context,
                    PageRouteBuilder(
                      settings: RouteSettings(
                        name: 'book${book.uid}',
                      ),
                      transitionDuration: const Duration(milliseconds: 400),
                      reverseTransitionDuration: const Duration(
                        milliseconds: 350,
                      ),
                      pageBuilder: (_, animation, __) => FadeTransition(
                        opacity: animation,
                        child: BookPage(
                          bookId: book.uid,
                        ),
                      ),
                    ),
                  ),),
          ),
        );
      },
    );

    if (widget.embedded){
      return Padding(padding: EdgeInsets.all(14),child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Goodread's for you",
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(color: Colors.black,fontSize: 16),
          ),
          SizedBox(height: 5,),
          Text(
            "Is Your money working for you , or are you working.",
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.black,fontSize: 14),
          ),
          list
        ],
      ) );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Column(children: [list]),
    );
  }
}

class _RevealOnBuild extends StatefulWidget {
  final Widget child;

  const _RevealOnBuild({super.key, required this.child});

  @override
  State<_RevealOnBuild> createState() => _RevealOnBuildState();
}

class _RevealOnBuildState extends State<_RevealOnBuild>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(_fade);

    Future.delayed(const Duration(milliseconds: 40), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

class _BookCardSkeleton extends StatelessWidget {
  const _BookCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [

        Container(
          width: 70,
          height: 100,
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 14,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 12,
                width: 120,
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

