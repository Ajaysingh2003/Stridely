import 'package:app/features/book/presentation/widget/Book_about.dart';
import 'package:app/features/book/presentation/widget/key_points.dart';
import 'package:flutter/material.dart';

class BookTab extends StatelessWidget {
  const BookTab({super.key, this.height = 1120});

  final double height;




  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;


   final String aboutStr =
    "Breadwinners (2025) delivers a profound exploration of how modern shifting income patterns and evolving gender roles are radically reshaping household power dynamics. By analyzing contemporary economic trends alongside real-world relationships, it provides a crucial playbook for navigating modern partnership, finance, and societal expectations.";

final String forWhomStr =
    "Perfect for couples aiming to build equitable financial partnerships, professionals balancing high-stakes careers with home life, sociologists tracking modern family dynamics, and anyone interested in how economic shifts alter our most personal relationships.";

final AuthorType authorData = AuthorType(
  authorName: "Susy Gala",
  authorBio: "Susy Gala is a researcher and cultural analyst specializing in modern economic structures and family dynamics. As the visionary behind Stridely, he combines deep sociological insights with data-driven research to help readers navigate the complexities of evolving societal norms.",
);    



  final List<KeyPoint> contents = [
    KeyPoint(id: "kp1", text: "First key concept overview data marker."),
    KeyPoint(id: "kp2", text: "Crucial strategic performance variable milestone."),
    KeyPoint(id: "kp3", text: "Final data summary calculation metric context."),
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
                 BookAbout(about: aboutStr, forWhom: forWhomStr, author: authorData),
                //  BookAbout(about: aboutStr, forWhom: forWhomStr, author: authorData),
                KeyPoints(points: contents)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
