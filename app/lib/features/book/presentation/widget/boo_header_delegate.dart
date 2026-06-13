import 'package:flutter/material.dart';

class ManualBookHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final Widget bookWidget;
  
  // 🚀 YOU DECIDE THESE HEIGHT BOUNDARIES HERE:
  final double maxExtent; // e.g., 380.0 when fully open
  final double minExtent; // e.g., 65.0 when fully collapsed

  ManualBookHeaderDelegate({
    required this.title,
    required this.bookWidget,
    required this.maxExtent,
    required this.minExtent,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    // 1. Calculate a smooth 0.0 to 1.0 scroll progress factor
    final double rawProgress = shrinkOffset / (maxExtent - minExtent);
    final double progress = rawProgress.clamp(0.0, 1.0);

    // 2. Control your inner image scale manually based on scroll position
    // This scales the book cover from 100% down to 55% as you scroll down
    final double imageScale = 1.0 - (progress * 0.45);
    
    // This fades the book view out entirely by the time it finishes collapsing
    final double imageOpacity = 1.0 - progress;

    return Container(
      height: maxExtent,
      color: const Color(0xFF0F172A), // Your collapsed bar background color
      child: Stack(
        children: [
          // ---- 1. MANUALLY ANIMATED BOOK COVER LAYOUT ----
          Positioned(
            top: 60, // Leave clean room for your action buttons at the top
            left: 0,
            right: 0,
            bottom: 0,
            child: Opacity(
              opacity: imageOpacity,
              child: Transform.scale(
                scale: imageScale,
                alignment: Alignment.topCenter,
                child: bookWidget, // Your <BookView /> component
              ),
            ),
          ),

          // ---- 2. FIXED NAVIGATION LAYER (Stays at your minExtent height) ----
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: minExtent,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.maybePop(context),
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 21),
                    ),
                    const SizedBox(width: 4),
                    // Title fades in ONLY near the very end of the scroll threshold
                    Expanded(
                      child: Opacity(
                        opacity: progress > 0.8 ? (progress - 0.8) * 5 : 0.0,
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.bookmark_add, color: Colors.white70, size: 23)),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.ios_share, color: Colors.white70, size: 23)),
                  ],
                ),
              ),
            ),
          ),

          // ---- 3. YOUR CUSTOM ACCENT GRADIENT BORDER ----
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 1,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF000000), Color(0xFF3B7BFB), Color(0xFF000000)],
                  stops: [0, 0.5, 1],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant ManualBookHeaderDelegate oldDelegate) {
    return title != oldDelegate.title || 
           bookWidget != oldDelegate.bookWidget ||
           maxExtent != oldDelegate.maxExtent ||
           minExtent != oldDelegate.minExtent;
  }
}