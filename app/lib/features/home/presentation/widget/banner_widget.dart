import 'package:app/features/home/presentation/widget/carousel_wrapper.dart';
import 'package:flutter/material.dart';
import 'dart:ui'; // ── 🎯 REQUIRED FOR THE BLUR FILTER EFFECT ──

class BannerWidget extends StatelessWidget {
  const BannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 0),
      clipBehavior: Clip.antiAlias, 
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8), // Smoother, modern radius
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1.0,
        ),

        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFFFFFF).withValues(alpha: 0.04),
            const Color.fromARGB(255, 172, 220, 255).withValues(alpha: 0.03),
            const Color.fromARGB(70, 250, 191, 225).withValues(alpha: 0.60), 
          ],
          stops: const [0.0, 0.1, 1.6],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.1),
            blurRadius: 3,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: BackdropFilter(

        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeader(context),
              const SizedBox(height: 12),
              const CarouselWrapper(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildHeader(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 22, // Slightly larger for better hierarchy
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w800,
                ),
                children: const [
                  TextSpan(text: "Today's "),
                  TextSpan(
                    text: "Free",
                    style: TextStyle(
                      color: Color(0xff4A8FE8), // Vibrant neon blue to match your app accent
                      shadows: [
                        Shadow(
                          color: Color(0x404A8FE8),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                  ),
                  TextSpan(text: " Pick"),
                ],
              ),
            ),
            
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            //   decoration: BoxDecoration(
            //     color: const Color(0xff4A8FE8).withValues(alpha: 0.15),
            //     borderRadius: BorderRadius.circular(20),
            //     border: Border.all(color: const Color(0xff4A8FE8).withValues(alpha: 0.3), width: 1),
            //   ),
            //   child: const Text(
            //     "FEATURED",
            //     style: TextStyle(
            //       color: Color(0xff4A8FE8),
            //       fontSize: 10,
            //       fontWeight: FontWeight.w800,
            //       letterSpacing: 1.0,
            //     ),
            //   ),
            // ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          "Selected by our curators", 
          style: TextStyle(
            color: Colors.black.withValues(alpha: 0.5), 
            fontSize: 13,
            letterSpacing: 0.3,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    ),
  );
}