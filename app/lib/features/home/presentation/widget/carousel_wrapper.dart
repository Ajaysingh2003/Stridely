import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselWrapper extends StatefulWidget {
  const CarouselWrapper({super.key});

  @override
  State<CarouselWrapper> createState() => _CarouselWrapperState();
}

class _CarouselWrapperState extends State<CarouselWrapper> {
  int _current = 0; // Track the current page index
  final CarouselSliderController _controller = CarouselSliderController();

  final List<String> imgList = [
    'https://images.unsplash.com/photo-1507842217343-583bb7270b66',
    'https://images.unsplash.com/photo-1481627834876-b7833e8f5570',
    'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: imgList.map((item) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              image: DecorationImage(image: NetworkImage(item), fit: BoxFit.cover),
            ),
          )).toList(),
          carouselController: _controller,
          options: CarouselOptions(
            autoPlay: true,
            viewportFraction: 0.6,
            enlargeCenterPage: true,
            aspectRatio: 1.0,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index; // Update the state when the page changes
              });
            },
          ),
        ),
          SizedBox(height: 20),
        // dots
        Row(

          mainAxisAlignment: MainAxisAlignment.center,
          children: imgList.asMap().entries.map((entry) {
            bool isActive = _current == entry.key;
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: isActive ? 32.0 : 8.0, // Made it slightly wider for the progress line
                height: 6.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                clipBehavior: Clip.antiAlias, // Ensures the progress bar stays inside the rounded corners
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: Colors.grey.withOpacity(0.7),
                ),
                child: isActive
                    ? LayoutBuilder(
                  builder: (context, constraints) {
                    return TweenAnimationBuilder<double>(
                      duration: const Duration(seconds: 3),
                      tween: Tween<double>(begin: 0.0, end: 1),
                      builder: (context, value, child) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: constraints.maxWidth * value,
                            color: Colors.white,
                          ),
                        );
                      },
                    );
                  },
                )
                    : null, // If not active, show nothing inside the dot
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}