import 'package:app/core/func/Navigate.dart';
import 'package:app/features/book/domain/entity/book_entity.dart';
import 'package:app/features/book/presentation/provider/book_data_provider.dart';
import 'package:app/features/bookmark/notifier/notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SavedBookEntry extends ConsumerWidget {
  final VoidCallback onTap;

  const SavedBookEntry({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 💡 FIXED: Changed from ref.read to ref.watch so the UI dynamically
    // updates the count whenever a bookmark is added or removed.
    // final  savedBookIds = ref.read(bookmarkRepositoryProvider).getBookmarkedIds();
    // final savedBookIds = ref.watch(bookmarkRepositoryProvider).getBookmarkedIds();


    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface.withOpacity(0.65),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colors.onSurface.withOpacity(0.06),
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.onSurface.withOpacity(0.02),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    // Visual "Stacked" Icon Container representing a collection
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Decorative offset background layer
                        Transform.translate(
                          offset: const Offset(3, -3),
                          child: Transform.rotate(
                            angle: 0.08,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: colors.primary.withOpacity(0.15),
                              ),
                            ),
                          ),
                        ),
                        // Top main interactive icon layer
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: colors.primary,
                            boxShadow: [
                              BoxShadow(
                                color: colors.primary.withOpacity(0.25),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.bookmark_rounded,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    // Typography Text Strings Block
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Saved Books",
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                              color: colors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          // Text(
                          //   count == 0 
                          //       ? "No items saved yet" 
                          //       : count == 1 
                          //           ? "1 book curated" 
                          //           : "$count books saved",
                          //   style: textTheme.bodySmall?.copyWith(
                          //     color: colors.onSurfaceVariant.withOpacity(0.7),
                          //     fontWeight: FontWeight.w400,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    // Clean Right Navigation Elements Block
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.onSurface.withOpacity(0.03),
                      ),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        size: 20,
                        color: colors.onSurfaceVariant.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}