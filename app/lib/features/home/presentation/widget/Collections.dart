import 'package:app/core/loader.dart';
import 'package:app/features/book/presentation/provider/book_data_provider.dart';
import 'package:app/features/book/presentation/screen/book_screen.dart';
import 'package:app/features/home/presentation/pages/single_collection.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Collections extends ConsumerStatefulWidget {
  const Collections({super.key});

  @override
  ConsumerState<Collections> createState() => _CollectionWidgetState();
}

class _CollectionWidgetState extends ConsumerState<Collections> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(booksControllerProvider.notifier).loadCollection();
    });
  }

  @override
  Widget build(BuildContext context) {
    final collectionState = ref.watch(booksControllerProvider);
    final collections = collectionState.collections;
    print('this is chiru $collections');
    if (collectionState.collectionLoading && collections.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: const SkeletonBlock(
                width: 160,
                height: 22,
                borderRadius: 4,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 270,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(14),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Container(
                    width: 175,
                    margin: const EdgeInsets.only(right: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AspectRatio(
                          aspectRatio: 0.7,
                          child: SkeletonBlock(
                            width: double.infinity,
                            height: double.infinity,
                            borderRadius: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const SkeletonBlock(
                          width: double.infinity,
                          height: 12,
                          borderRadius: 4,
                        ),
                        const SizedBox(height: 4),
                        const SkeletonBlock(
                          width: 60,
                          height: 12,
                          borderRadius: 4,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    if (collections.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 🎯 ROW HEADER ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Collections",
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                    letterSpacing: 0.5,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── 📜 HORIZONTAL SCROLLABLE LISTVIEW ──
          SizedBox(
            height: 190,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemCount: collections.length,
              itemBuilder: (context, index) {
                final collection = collections[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
      context,
      PageRouteBuilder(
        settings: RouteSettings(name: 'book_page_${collection.uid}'),
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: animation,
          child: SingleCollectionPage(
            title: collection.title,
            coverUrl: collection.coverUrl ,
            description: collection.description,
            collectionId: collection.uid,
            // heroTag: _heroTag,
          ),
        ),
      ),
    );
                  },
                  child: Container(
                    width: 195,
                    margin: const EdgeInsets.only(right: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── 🌟 THE FIX: Wrap in Expanded so the vertical layout behaves ──
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.12),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: collection.coverUrl ?? "",
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // 📝 Title Segment
                        Text(
                          collection.title ?? "",
                          maxLines: 2,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
