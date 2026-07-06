import 'package:app/features/book/presentation/provider/book_data_provider.dart';
import 'package:app/features/book/presentation/screen/book_screen.dart';
import 'package:app/features/home/presentation/widget/StackCarousel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InsightsPage extends ConsumerWidget {
  final String author;
  final String bookId;
  final List<String> insights;

  const InsightsPage({
    super.key,
    required this.author,
    required this.bookId,
    required this.insights,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookAsync = ref.watch(singleBookProvider(bookId));

    return Scaffold(
      backgroundColor: const Color.fromARGB(
        255,
        98,
        98,
        98,
      ), // Deep dark matte theme background
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 98, 98, 98),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: bookAsync.when(
        // ── 🟢 1. DATA SUCCESS BRANCH ──
        data: (eitherResult) {
          return eitherResult.fold(
            (failure) => Center(
              child: Text(
                'Backend Failure: ${failure.message}',
                style: const TextStyle(color: Colors.white70),
              ),
            ),
            (bookData) {
              return Column(
                children: [
                  // ── A. MAIN SCROLLABLE CONTENT AREA ──
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (insights.isEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 40.0),
                              child: Center(
                                child: Text(
                                  "No insights available for this book yet.",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.4),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            )
                          else
                            // The custom swipe deck runs freely inside the scrolling area
                            StackCarousel(
                              insights: bookData.quotes,
                              author: bookData.author.name,
                            ),
                        ],
                      ),
                    ),
                  ),

                  // ── B. BOTTOM BANNER LAYER (PIECE-BY-PIECE MATCH) ──
                  SafeArea(
                    top:
                        false, // Ensures padding rules only defend the bottom notch area
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFF070E14,
                        ), // Pure dark sub-panel background
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                      child: GestureDetector(
                        child: Row(
                          children: [
                            // Book Thumbnail Cover Simulation Placeholder
                            Container(
                              width: 44,
                              height: 58,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: bookData.bookCover,
                                fit: .cover,
                              ),
                            ),
                            const SizedBox(width: 14),

                            // Book Title Meta Info String Context Block
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    "More about this insight in:",
                                    style: TextStyle(
                                      color: Color(0xff4A8FE8),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    bookData.title ?? "Untitled",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 1),
                                  Text(
                                    bookData.author.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Action Arrow Chevron
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white.withOpacity(0.4),
                              size: 16,
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              // Replace 'BookDetailsPage' with the actual class name of your target book details view file
                              builder: (context) =>
                                  BookPage(bookId: bookData.uid),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },

        // ── 🔴 2. ERROR BOUNDARY BRANCH ──
        error: (error, stackTrace) {
          return Center(
            child: Text(
              "Oops! Something went wrong: $error",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
          );
        },

        // ── 🟡 3. LOADING SCREEN BRANCH ──
        loading: () {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xff4A8FE8)),
          );
        },
      ),
    );
  }
}
