import 'dart:async';

import 'package:app/core/app_background.dart';
import 'package:app/features/book/presentation/provider/book_data_provider.dart';
import 'package:app/features/book/presentation/screen/book_screen.dart';
import 'package:app/features/home/data/state/recent_search_state.dart';
import 'package:app/features/home/presentation/provider/home_provider.dart';
import 'package:app/features/home/presentation/widget/book_search_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchWidget extends ConsumerStatefulWidget {
  final bool isExpanded;
  const SearchWidget({super.key, this.isExpanded = false});

  @override
  ConsumerState<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends ConsumerState<SearchWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _hasText = false;
  Timer? _debounce;

  final List<String> _suggestedCategories = [
    'Self-improvement',
    'Business',
    'Psychology',
    'Productivity',
    'Biography',
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final text = _controller.text.trim();
    final hasText = text.isNotEmpty;

    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }

    _debounce?.cancel();

    if (text.isEmpty) {
      // User cleared the field — reset results so the view falls back
      // to the browse state instead of showing stale results.
      ref.read(searchBooksControllerProvider.notifier).clearResults();
      return;
    }

    // Live search as you type, like Udemy — pauses briefly so it
    // doesn't fire a request on every keystroke.
    _debounce = Timer(const Duration(milliseconds: 800), () {
      ref.read(searchBooksControllerProvider.notifier).searchBooks(text);
    });
  }

  void _submitSearch(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;
    _debounce?.cancel();
    ref.read(recentSearchProvider.notifier).addSearch(trimmed);
    ref.read(searchBooksControllerProvider.notifier).searchBooks(trimmed);
  }

  void _clearSearch() {
    _debounce?.cancel();
    _controller.clear();
    ref.read(searchBooksControllerProvider.notifier).clearResults();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'search-hero',
      child: Material(
        type: MaterialType.transparency,
        child: widget.isExpanded
            ? _buildExpandedSearch(context)
            : _buildCollapsedSearch(context),
      ),
    );
  }

  // ─── COLLAPSED SEARCH BAR ────────────────────────────────────────────────
  Widget _buildCollapsedSearch(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 300),
            reverseTransitionDuration: const Duration(milliseconds: 250),
            pageBuilder: (_, animation, __) =>
                FadeTransition(opacity: animation, child: const _SearchPage()),
          ),
        );
      },
      child: Container(
        height: 48,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.outlineVariant.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search_rounded,
              color: colors.onSurfaceVariant,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              "Search books...",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  // ─── EXPANDED SEARCH ──────────────────────────────────────────────────────
  Widget _buildExpandedSearch(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final state = ref.watch(searchBooksControllerProvider);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () => Navigator.maybePop(context),
                  color: colors.primary,
                ),
                Expanded(
                  child: Container(
                    height: 46,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search_rounded,
                          color: colors.onSurfaceVariant,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            onSubmitted: _submitSearch,
                            focusNode: _focusNode,
                            autofocus: true,
                            textInputAction: TextInputAction.search,
                            style: Theme.of(context).textTheme.bodyMedium,
                            decoration: InputDecoration(
                              hintText: "Search for books, authors, topics...",
                              hintStyle: TextStyle(
                                color: colors.onSurfaceVariant,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                        if (_hasText)
                          GestureDetector(
                            onTap: _clearSearch,
                            child: Icon(
                              Icons.close_rounded,
                              size: 18,
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          Expanded(
            child:
                (!_hasText ||
                    state.books.isEmpty &&
                        !state.isLoading &&
                        state.errorMessage == null)
                ? (_hasText ? _buildResultsList() : _buildBrowseState(context))
                : _buildResultsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList() {
    final state = ref.watch(searchBooksControllerProvider);
    final colors = Theme.of(context).colorScheme;

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.books.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 48,
                color: colors.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                "No results found",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                "Try a different title, author, or topic.",
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _clearSearch,
                child: const Text("Clear search"),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "All results",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: state.books.length,
              itemBuilder: (context, i) {
                final book = state.books[i];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        settings: RouteSettings(name: 'book_page_${book.uid}'),
                        transitionDuration: const Duration(milliseconds: 400),
                        reverseTransitionDuration: const Duration(
                          milliseconds: 350,
                        ),
                        pageBuilder: (_, animation, __) => FadeTransition(
                          opacity: animation,
                          child: BookPage(
                            bookId: book.uid,
                            // heroTag: _heroTag,
                          ),
                        ),
                      ),
                    );
                  },
                  child: BookSearchResult(book: book),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrowseState(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final recentSearches = ref.watch(recentSearchProvider);

    final List<String> suggestions = const [
      'Self-improvement',
      'Business',
      'Psychology',
    ];

    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        if (recentSearches.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recent searches",
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () {
                  ref.read(recentSearchProvider.notifier).clear();
                },
                child: Text(
                  "Clear",
                  style: textTheme.bodySmall?.copyWith(color: colors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...recentSearches.map(
            (search) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  _controller.text = search;
                  _controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: search.length),
                  );
                  setState(() => _hasText = true);
                  _debounce?.cancel();
                  ref
                      .read(searchBooksControllerProvider.notifier)
                      .searchBooks(search);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.history_rounded,
                        size: 18,
                        color: colors.onSurfaceVariant,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(search, style: textTheme.bodyMedium),
                      ),
                      Icon(
                        Icons.north_west_rounded,
                        size: 16,
                        color: colors.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ] else ...[
          Text(
            "Suggestion's",
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          ...suggestions.map(
            (suggestion) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  _controller.text = suggestion;
                  _controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: suggestion.length),
                  );
                  setState(() => _hasText = true);
                  _debounce?.cancel();
                  ref
                      .read(searchBooksControllerProvider.notifier)
                      .searchBooks(suggestion);
                },

                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(suggestion, style: textTheme.titleSmall),
                      ),
                      Icon(
                        Icons.north_west_rounded,
                        size: 16,
                        color: colors.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],

        Text(
          "Browse categories",
          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _suggestedCategories.map((category) {
            return InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                _controller.text = category;
                setState(() => _hasText = true);
                _debounce?.cancel();
                ref.read(recentSearchProvider.notifier).addSearch(category);
                ref
                    .read(searchBooksControllerProvider.notifier)
                    .searchBooks(category);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: colors.outlineVariant),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(category, style: textTheme.bodySmall),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _SearchPage extends StatelessWidget {
  const _SearchPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AppBackground(child: SearchWidget(isExpanded: true)),
    );
  }
}
