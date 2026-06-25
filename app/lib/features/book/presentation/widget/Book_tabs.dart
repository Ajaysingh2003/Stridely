import 'package:app/features/book/domain/entity/book_entity.dart';
import 'package:app/features/book/presentation/widget/Book_about.dart';
import 'package:app/features/book/presentation/widget/Excerpt.dart';
import 'package:app/features/book/presentation/widget/key_points.dart';
import 'package:app/features/book/presentation/widget/what_you_learn.dart';
import 'package:flutter/material.dart';

// class AuthorType {
//   final String authorName;
//   final String authorBio;

//   const AuthorType({required this.authorName, required this.authorBio});

//   factory AuthorType.fromJson(Map<String, dynamic> json) {
//     return AuthorType(
//       authorName: json['authorName'] ?? 'Unknown Author',
//       authorBio: json['authorBio'] ?? '',
//     );
//   }
// }

class BookTab extends StatelessWidget {
  final BookEntity book;
  const BookTab({super.key, this.height = 1120, required this.book});

  final double height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final String aboutStr = book.aboutBook ?? "";

    final String forWhomStr = book.forWhom ?? "";

    final AuthorType authorData = AuthorType(
      name: book.author.name,
      bio: book.author.bio,
    );

    final List<KeyPoint> contents = [
      KeyPoint(id: "kp1", text: "First key concept overview data marker."),
      KeyPoint(
        id: "kp2",
        text: "Crucial strategic performance variable milestone.",
      ),
      KeyPoint(
        id: "kp3",
        text: "Final data summary calculation metric context.",
      ),
    ];

    return DefaultTabController(
      length: 4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.12),
                  // color: Colors.red,
                  width: 1,
                ),
              ),
            ),
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelPadding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              physics: const BouncingScrollPhysics(),
              indicatorSize: TabBarIndicatorSize.label,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(width: 2.5, color: colorScheme.primary),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(2),
                ),
              ),
              labelColor: colorScheme.primary,
              unselectedLabelColor: colorScheme.onSurface.withValues(
                alpha: 0.5,
              ),
              labelStyle: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 0.1,
              ),
              unselectedLabelStyle: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                // color: Colors.amber,
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
          SizedBox(
            height: height,
            child: TabBarView(
              physics: BouncingScrollPhysics(),
              children: [
                BookAbout(
                  about: aboutStr,
                  forWhom: forWhomStr,
                  author: authorData,
                ),
                //  BookAbout(about: aboutStr, forWhom: forWhomStr, author: authorData),
                KeyPoints(points: contents),
                Learning(learning: book.whatsInside),
                // Learning(learning: book.whatsInside),
                Excerpt(excerpt: book.quotes)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
