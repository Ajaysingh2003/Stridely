import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FreeBooksSkeleton extends StatelessWidget {
  const FreeBooksSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    // Deep dark background color palette matching your home view layout shell
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return SizedBox(
      height: 220,
      child: Shimmer.fromColors(
        baseColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[300]!,
        highlightColor: isDark ? Colors.white.withOpacity(0.12) : Colors.grey[100]!,
        period: const Duration(milliseconds: 1500),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const NeverScrollableScrollPhysics(), // Keeps it locked while loading
          itemCount: 4, // Fits nicely across the viewport horizontal profile bounds
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 24, top: 10, bottom: 10),
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..rotateY(-0.15)
                  ..rotateZ(-0.03),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // PAGE EDGE SIMULATION
                    Positioned(
                      left: -5,
                      top: 10,
                      bottom: 10,
                      child: Container(
                        width: 10,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    // SPINE SIMULATION
                    Positioned(
                      left: 0,
                      top: 6,
                      bottom: 6,
                      child: Container(
                        width: 14,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    // MAIN FRONT COVER SKELETON BOX
                    Container(
                      width: 110, // Matches your card's proportional visual width profile 
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}