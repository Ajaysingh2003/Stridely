import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FreeBooksSkeleton extends StatelessWidget {
  const FreeBooksSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      // Use LayoutBuilder to ensure constraints are passed safely during the first frame
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Shimmer.fromColors(
            // Neutral light-theme colors
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            period: const Duration(milliseconds: 1500),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 24, top: 10, bottom: 10),
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.002)
                      ..rotateY(-0.2),
                    child: SizedBox(
                      width: 110,
                      height: 180,
                      child: Stack(
                        children: [
                          // Main Cover
                          Container(
                            width: 110,
                            height: 180,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          // Page Edge / Shadow Effect
                          Positioned(
                            right: 0,
                            top: 0,
                            bottom: 0,
                            width: 30,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.0),
                                    Colors.black.withOpacity(0.1),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}