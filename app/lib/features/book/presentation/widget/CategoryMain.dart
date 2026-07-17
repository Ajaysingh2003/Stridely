import 'package:app/core/func/Navigate.dart';
import 'package:app/features/book/presentation/provider/book_data_provider.dart';
import 'package:app/features/book/presentation/widget/categories_loader.dart';
import 'package:app/features/book/presentation/widget/category_helper.dart';
import 'package:app/features/home/domain/entity/category_entity.dart';
import 'package:app/features/home/presentation/pages/category_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryScroll extends ConsumerStatefulWidget {
  final ValueChanged<String>? onCategorySelected;

  const CategoryScroll({super.key, this.onCategorySelected});

  @override
  ConsumerState<CategoryScroll> createState() => _CategoryScrollState();
}

class _CategoryScrollState extends ConsumerState<CategoryScroll> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(booksControllerProvider.notifier).loadCategory();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(booksControllerProvider);

    if (state.categoryLoading) {
      return CategoriesLoader();
    }

    final categories = state.categories;

    // final icon = CategoryIconHelper.getIconForCategory(category.title);

    if (categories.isEmpty) {
      return const SizedBox(height: 100);
    }

    final topRow = <CategoryEntity>[];
    final bottomRow = <CategoryEntity>[];

    for (int i = 0; i < categories.length; i++) {
      if (i.isEven) {
        topRow.add(categories[i]);
      } else {
        bottomRow.add(categories[i]);
      }
    }

    return SizedBox(
      height: 100,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: topRow.map((category) {
                final icon = CategoryIconHelper.getIconForCategory(
                  category.title,
                );

                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: _CategoryChip(
                    icon: icon,
                    title: category.title,
                    onTap: () => moveTo(
                        context,
                        CategoryPages(
                          title: category.title,
                          coverUrl: "...",
                          categoryId: category.uid,
                        ),
                        '$category.uid',
                      ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Row(
                children: bottomRow.map((category) {
                  final icon = CategoryIconHelper.getIconForCategory(
                    category.title,
                  );
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: _CategoryChip(
                      icon: icon,
                      title: category.title,
                      onTap: () => moveTo(
                        context,
                        CategoryPages(
                          title: category.title,
                          coverUrl: "...",
                          categoryId: category.uid,
                        ),
                        '$category.uid',
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatefulWidget {
  final String title;
  final VoidCallback onTap;
  final IconData icon;
  const _CategoryChip({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<_CategoryChip> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _pressed = true);
      },
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () {
        setState(() => _pressed = false);
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        scale: _pressed ? .97 : 1,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: _pressed ? const Color(0xFFEFF5FF) : const Color(0xFFF7F8FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _pressed
                  ? const Color(0xFFC8D9FF)
                  : const Color(0xFFE6EAF1),
              width: 1,
            ),
          ),
          child: Center(
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  size: 18,
                  color: colors.primary,
                ),

                SizedBox(width: 6),

                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -.15,
                    color: colors.onSurface.withOpacity(.82),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
