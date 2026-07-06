import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class PurchaseCarousel extends StatefulWidget {
  const PurchaseCarousel({super.key});

  @override
  State<PurchaseCarousel> createState() => _PurchaseCarouselState();
}

class _PurchaseCarouselState extends State<PurchaseCarousel> {
  final CarouselSliderController _controller = CarouselSliderController();
  int _current = 0;

  final List<String> _images = const [
    "assets/posters/poster_1.png",
    "assets/posters/poster_2.png",
    "assets/posters/poster_3.png",
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      // ── 🎯 THE FIX: Removed horizontal padding here so the carousel spans edge-to-edge ──
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      clipBehavior: Clip.none,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CarouselSlider.builder(
            itemCount: _images.length,
            carouselController: _controller,
            options: CarouselOptions(
              height: 210,
              viewportFraction: 0.96,
              enlargeCenterPage: true,
              enlargeStrategy: CenterPageEnlargeStrategy.scale,
              padEnds: true,
              autoPlay: true,
              autoPlayCurve: Curves.easeInOut,
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayInterval: const Duration(seconds: 4),
              enableInfiniteScroll: true,
              onPageChanged: (index, reason) {
                setState(() => _current = index);
              },
            ),
            itemBuilder: (context, index, realIndex) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOut,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(_images[index], fit: BoxFit.fill),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(

                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(.12),
                              Colors.black.withOpacity(.45),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_images.length, (index) {
              final active = index == _current;

              return GestureDetector(
                onTap: () => _controller.animateToPage(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 26 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: active
                        ? theme.colorScheme.primary
                        : Colors.grey.shade300,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}