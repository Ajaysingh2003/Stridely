import 'package:app/features/book/domain/entity/insights_entity.dart';
import 'package:app/features/book/presentation/provider/book_data_provider.dart';
import 'package:app/features/home/presentation/pages/insights_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InsightsView extends ConsumerStatefulWidget {
  const InsightsView({super.key});

  @override
  ConsumerState<InsightsView> createState() => _InsightsViewState();
}

class _InsightsViewState extends ConsumerState<InsightsView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(booksControllerProvider.notifier).loadInsights();
    });
  }

  @override
  Widget build(BuildContext context) {
    final insightsState = ref.watch(booksControllerProvider).insights;
    
    // Smooth looping calculation array payload list
    final List structuralList = List.generate(22, (_) => insightsState).expand((i) => i).toList();

    // ── 🎯 THE FIX: Removed outer structural margin from this root wrapper container ──
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 🎯 THE FIX: Isolated headings here to lock them to the 14px cushion line ──
        Padding(
          padding: const EdgeInsets.only(left: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Insights",
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                  letterSpacing: 1.3,
                ),
              ),
              Text(
                "Learn 5 key insights in just 1 minute",
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                  letterSpacing: 1.3,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 110, 
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            // ── 🎯 THE FIX: Generates inline initial gap padding without restricting active viewport scroll boundaries ──
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            // ── 🎯 THE FIX: Disables explicit container viewport canvas clipping completely ──
            clipBehavior: Clip.none, 
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(
                decelerationRate: ScrollDecelerationRate.normal, 
              ),
            ),
            itemCount: structuralList.length,
            itemBuilder: (context, index) {
              final singleInsight = structuralList[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: InsightsCard(card: singleInsight),
              );
            },
          ),
        ),
      ],
    );
  }
}

class InsightsCard extends StatelessWidget {
  final InsightsEntity card;
  const InsightsCard({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque, 
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InsightsPage(
                author: card.author,
                bookId: card.bookId,
                insights: card.insights,
              ),
            ),
          );
        },
        child: Container(
          width: 70,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color.fromARGB(255, 255, 47, 123)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: card.coverUrl,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.low,
              fadeInDuration: const Duration(milliseconds: 200), 
              placeholder: (context, url) => Container(color: Colors.white.withOpacity(0.05)),
              errorWidget: (context, url, error) => const Icon(Icons.broken_image, color: Colors.white24),
            ),
          ),
        ),
      ),
    );
  }
}