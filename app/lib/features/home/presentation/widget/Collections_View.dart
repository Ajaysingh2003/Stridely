import 'dart:ui';

import 'package:app/core/loader.dart';
import 'package:app/features/book/presentation/provider/book_data_provider.dart';
import 'package:app/features/book/presentation/screen/book_screen.dart';
import 'package:app/features/home/presentation/pages/single_collection.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CollectionsView extends ConsumerStatefulWidget {
  const CollectionsView({super.key});

  @override
  ConsumerState<CollectionsView> createState() => _CollectionsViewState();
}

class _CollectionsViewState extends ConsumerState<CollectionsView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(booksControllerProvider.notifier).loadCollection(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(booksControllerProvider);

    if (state.collectionLoading && state.collections.isEmpty) {
      return const SizedBox.shrink();
    }

    if (state.collections.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 14),
      itemCount: state.collections.length,
      itemBuilder: (context, index) {
        return _CollectionCard(collection: state.collections[index]);
      },
    );
  }
}

class _CollectionCard extends ConsumerStatefulWidget {
  final dynamic collection;

  const _CollectionCard({required this.collection});

  @override
  ConsumerState<_CollectionCard> createState() => _CollectionCardState();
}

class _CollectionCardState extends ConsumerState<_CollectionCard> {
  // ─── LAYOUT CONSTANTS ──────────────────────────────────────────────────
  static const double _cardHeight = 250;
  static const double _cardBorderRadius = 12;
  static const double _titleTopOffset = 50;
  static const double _titleScrimHeight = 110;
  static const double _coverBottomOffset = -80;

  bool _isPressed = false;

  String get _heroTag => 'collection_hero_${widget.collection.uid}';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final state = ref.read(
        filterdBooksCollectionControllerProvider(widget.collection.uid),
      );
      if (state.books.isEmpty) {
        ref
            .read(
              filterdBooksCollectionControllerProvider(
                widget.collection.uid,
              ).notifier,
            )
            .loadFilterdBooks(
              collectionId: widget.collection.uid,
              limit: 3,
              isRefresh: true,
            );
      }
    });
  }

  void _openCollection() {
    Navigator.push(
      context,
      PageRouteBuilder(
        settings: RouteSettings(name: 'book_page_${widget.collection.uid}'),
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: animation,
          child: SingleCollectionPage(
            title: widget.collection.title,
            coverUrl: widget.collection.coverUrl ,
            description: widget.collection.description,
            collectionId: widget.collection.uid,
            // heroTag: _heroTag,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookState = ref.watch(
      filterdBooksCollectionControllerProvider(widget.collection.uid),
    );
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: bookState.isLoading
          ? Padding(
              key: const ValueKey('skeleton'),
              padding: const EdgeInsets.all(14),
              child: SkeletonBlock(
                width: double.infinity,
                height: _cardHeight,
                borderRadius: _cardBorderRadius,
              ),
            )
          : Semantics(
              key: const ValueKey('card'),
              label: widget.collection.title ?? 'Collection',
              button: true,
              child: GestureDetector(
                onTapDown: (_) => setState(() => _isPressed = true),
                onTapUp: (_) => setState(() => _isPressed = false),
                onTapCancel: () => setState(() => _isPressed = false),
                onTap: _openCollection,
                child: AnimatedScale(
                  scale: _isPressed ? 0.97 : 1.0,
                  duration: const Duration(milliseconds: 120),
                  curve: Curves.easeOut,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Hero(
                      tag: _heroTag,
                      flightShuttleBuilder:
                          (context, animation, direction, fromContext, toContext) {
                        return ScaleTransition(
                          scale: Tween<double>(begin: 1.0, end: 1.02).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOut,
                            ),
                          ),
                          child: direction == HeroFlightDirection.push
                              ? toContext.widget
                              : fromContext.widget,
                        );
                      },
                      child: Container(
                        height: _cardHeight,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(_cardBorderRadius),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.shadow.withOpacity(0.1),
                              blurRadius: 5,
                              offset: const Offset(0, 1),
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(_cardBorderRadius),
                          child: Stack(
                            children: [
                              // Blur layer
                              BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 5.0,
                                  sigmaY: 5.0,
                                ),
                                child: Container(
                                  color: colorScheme.surface.withOpacity(0.5),
                                ),
                              ),

                              // Secondary cover image, bleeding off the bottom
                              if (widget.collection.secondaryCoverUrl != null)
                                Positioned(
                                  right: 0,
                                  left: 0,
                                  bottom: _coverBottomOffset,
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        widget.collection.secondaryCoverUrl,
                                    fit: BoxFit.fill,
                                    fadeInDuration:
                                        const Duration(milliseconds: 250),
                                    placeholder: (_, __) =>
                                        const SizedBox.shrink(),
                                    errorWidget: (_, __, ___) =>
                                        const SizedBox.shrink(),
                                  ),
                                ),

                              // Gradient scrim behind the title
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                height: _titleScrimHeight,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        colorScheme.surface.withOpacity(0.9),
                                        colorScheme.surface.withOpacity(0.0),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // Title
                              Positioned(
                                top: _titleTopOffset,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Text(
                                      widget.collection.title ?? "",
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                            color: colorScheme.onSurface,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}