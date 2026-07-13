import 'package:flutter/material.dart';

class BookEmpty extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final VoidCallback? onExplore;

  const BookEmpty({
    super.key,
    this.title,
    this.subtitle,
    this.onExplore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 40,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            /// Illustration
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.menu_book_rounded,
                size: 48,
                color: colors.primary,
              ),
            ),

            const SizedBox(height: 28),

            Text(
              title ?? "Nothing to read yet",
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              subtitle ??
                  "We're preparing personalized recommendations for you.\nCheck back in a little while.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
                height: 1.6,
              ),
            ),

            if (onExplore != null) ...[
              const SizedBox(height: 30),

              FilledButton.icon(
                onPressed: onExplore,
                icon: const Icon(Icons.explore_outlined),
                label: const Text("Explore Library"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}