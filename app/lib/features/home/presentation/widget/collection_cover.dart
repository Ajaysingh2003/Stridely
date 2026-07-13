import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class CollectionCover extends StatelessWidget {
  final String poster;

  const CollectionCover({super.key, required this.poster});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double posterHeight = screenWidth * 0.55;
    final double posterWidth = posterHeight * 1;

    final themeColors = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      height: posterHeight + 20,
      child: Center(
        child: Container(
          width: posterWidth,
          height: posterHeight,

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.red,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(120),
                blurRadius: 4,
                spreadRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: poster,
              fit: BoxFit.cover,
              fadeInDuration: const Duration(milliseconds: 250),
              
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: const Color(
                  0xFF2A2828,
                ), // The main background color of the skeleton card
                highlightColor: const Color(
                  0xFF3A3838,
                ), // The shining light color that sweeps across it
                period: const Duration(
                  milliseconds: 1500,
                ), // Controls how fast the wave moves
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color:
                      Colors.white, // This color acts as a mask, keep it white
                ),
              ),

              // 4. 🚀 The fallback UI if the URL breaks or network is lost entirely
              errorWidget: (context, url, error) => Container(
                color: const Color(0xFF2D2A2A),
                padding: const EdgeInsets.all(16),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.menu_book_rounded,
                      color: Colors.white38,
                      size: 40,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Cover Unavailable",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
