import 'package:flutter/material.dart';

class StackCarousel extends StatefulWidget {
  final List<String> insights;
  final String author;
  const StackCarousel({super.key, required this.insights,required this.author});

  @override
  State<StackCarousel> createState() => _StackCarouselState();
}

class _StackCarouselState extends State<StackCarousel> {
  int currentIndex = 0;
  double dragOffset = 0.0; // Tracks the live swipe distance of the top card

  @override
  Widget build(BuildContext context) {
    if (widget.insights.isEmpty) {
      return const Center(child: Text("No insights available.", style: TextStyle(color: Colors.white)));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── 1. THE LAYERING CARD STACK VIA GESTURE SWIPING ──
        GestureDetector(
          onHorizontalDragUpdate: (details) {
            setState(() {
              dragOffset += details.primaryDelta!;
            });
          },
          onHorizontalDragEnd: (details) {
            const swipeThreshold = 100.0;
            
            setState(() {
              if (dragOffset > swipeThreshold && currentIndex > 0) {
                currentIndex--;
              } 
              else if (dragOffset < -swipeThreshold && currentIndex < widget.insights.length - 1) {
                currentIndex++;
              }
              dragOffset = 0.0;
            });
          },
          child: SizedBox(
            height: 440,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                for (int i = widget.insights.length - 1; i >= currentIndex; i--)
                  if (i <= currentIndex + 2) _buildCard(i)
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 24),

        // ── 2. RECTANGULAR PROGRESS INDICATORS ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: List.generate(widget.insights.length, (index) {
              final bool isPassedOrCurrent = index <= currentIndex;
              return Expanded(
                child: Container(
                  height: 3,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: isPassedOrCurrent 
                        ? Colors.white.withOpacity(0.8) 
                        : Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildCard(int index) {
    final bool isTopCard = index == currentIndex;
    final double depthDiff = (index - currentIndex).toDouble(); 
    
    // ── 🎯 FIX: Hand off width management to Center/Transform, avoiding raw left pixel calculations ──
    double topPosition = 20 - (depthDiff * 12);
    double cardScale = 1.0 - (depthDiff * 0.04);
    double cardOpacity = (1.0 - (depthDiff * 0.25)).clamp(0.0, 1.0);

    // Calculate live sliding offset matrix targets
    double horizontalTranslation = 0.0;
    if (isTopCard) {
      horizontalTranslation = dragOffset;
    } else {
      // Moves background cards slightly to the right to simulate your stacked book visual edge depth look
      horizontalTranslation = depthDiff * 8; 
    }

    return AnimatedPositioned(
      duration: dragOffset == 0.0 ? const Duration(milliseconds: 300) : Duration.zero,
      curve: Curves.easeOutCubic,
      top: topPosition, // Keeps vertical stacking offsets clean
      child: Transform.translate(
        offset: Offset(horizontalTranslation, 0), // ── 🎯 FIX: Handles swiping cleanly without breaking layout centering ──
        child: AnimatedScale(
          duration: const Duration(milliseconds: 300),
          scale: cardScale,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: cardOpacity,
            child: _CardLayoutSurface(
              text: widget.insights[index],
              indexNumber: index + 1,
              totalCount: widget.insights.length,
              author: widget.author,
            ),
          ),
        ),
      ),
    );
  }
}

class _CardLayoutSurface extends StatelessWidget {
  final String text;
  final int indexNumber;
  final int totalCount;
  final String author;
  const _CardLayoutSurface({
    required this.text,
    required this.indexNumber,
    required this.totalCount,
    required this.author

  });

  @override
  Widget build(BuildContext context) {
    // ── 🎯 FIX: Dynamic width limit ensures it doesn't spill over on smaller mobile screens ──
    double optimizedWidth = MediaQuery.of(context).size.width * 0.88;
    if (optimizedWidth > 390) optimizedWidth = 390;

    return Container(
      width: optimizedWidth,
      height: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F9), 
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.menu_book_rounded, color: Colors.black87, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    "Booksly",
                    style: TextStyle(color: Colors.black.withOpacity(0.8), fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
              // Icon(Icons.ios_share_rounded, color: Colors.black.withOpacity(0.7), size: 18),
            ],
          ),
          const Spacer(),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF0F2440),
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
          ),
          SizedBox(height: 20,),
          Text(
            '-- $author',
            style: const TextStyle(
              color: Color(0xFF0F2440),
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Insight $indexNumber of $totalCount",
                style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 13, fontWeight: FontWeight.w500),
              ),
              // const Icon(Icons.play_circle_fill_rounded, color: Colors.black87, size: 26),
            ],
          ),
        ],
      ),
    );
  }
}