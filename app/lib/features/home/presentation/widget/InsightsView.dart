import 'package:app/features/book/domain/entity/book_entity.dart';
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
    
    final List structuralList = List.generate(1, (_) => insightsState).expand((i) => i).toList();

if (insightsState.isEmpty){
  return SizedBox();
}
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
                  color: Colors.black87,
                  letterSpacing: 1.3,
                  fontSize: 12,
                
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
            itemCount: insightsState.length,
            itemBuilder: (context, index) {
              final singleInsight = insightsState[index];
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

class InsightsCard extends ConsumerWidget {
  final BookEntity card;
  const InsightsCard({super.key, required this.card});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. WATCH the provider instead of reading/awaiting
    final bookAsync = ref.watch(singleBookProvider(card.uid));

    return bookAsync.when(
      data: (eitherResult) =>eitherResult.fold((failure)=>Center(child: Text(failure.message),), (bookData)=>GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InsightsPage(
                author: card.author.name,
                bookId: card.uid,
                insights: card.quotes,
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
              imageUrl: bookData.bookCover ?? "",
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),), 
      
      // 2. Handle Loading and Error states gracefully
      loading: () => Container(width: 70, height: 100, color: Colors.white10),
      error: (_, __) => Container(width: 70, height: 100, child: Icon(Icons.error)),
    );
  }
}