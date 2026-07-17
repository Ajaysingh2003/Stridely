import 'package:app/core/func/Navigate.dart';
import 'package:app/features/book/domain/entity/book_entity.dart';
import 'package:app/features/book/presentation/provider/book_data_provider.dart';
import 'package:app/features/bookmark/notifier/notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SavedBookEntry extends ConsumerWidget {
  // final int savedCount;
  final VoidCallback onTap;

  const SavedBookEntry({
    super.key,
    // required this.savedCount,
    required this.onTap,
  });


  @override
  Widget build(BuildContext context ,WidgetRef ref) {



    final savedbooks =ref.read(bookmarkRepositoryProvider).getBookmarkedIds();
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;



    return Padding(padding: EdgeInsets.symmetric(horizontal: 14),child:  Material(
      
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colors.primary.withOpacity(0.14),
                      colors.primary.withOpacity(0.04),
                    ],
                  ),
                  border: Border.all(
                    color: colors.primary.withOpacity(0.14),
                    width: 0.5,
                  ),
                ),
                child: Icon(
                  Icons.bookmark_rounded,
                  size: 20,
                  color: colors.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Text(
                      "Saved books",
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.1,
                        color: colors.onSurface,
                      ),
                    ),

                    const SizedBox(height: 2),

                    // Text(
                    //   savedbooks == 1 ? "1 book" : "$savedbooks books",
                    //   style: textTheme.bodySmall?.copyWith(
                    //     color: colors.onSurfaceVariant,
                    //   ),
                    // ),


                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: colors.onSurfaceVariant.withOpacity(0.6),
              ),
            ],
          ),
        ),
      ),
    ),);
  }
}