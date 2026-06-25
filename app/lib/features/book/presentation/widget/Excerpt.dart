import 'package:app/features/book/presentation/widget/ExcerptCarousel.dart';
import 'package:app/features/home/presentation/pages/home_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Excerpt extends StatelessWidget {
  final List<String> excerpt;
  final CarouselSliderController _controller = CarouselSliderController();
  Excerpt({super.key, required this.excerpt});


 

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Feature Excerpt",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 20
            ),
          ),
          SizedBox(height: 15),

          Container(
            child:Excerptcarousel(list: excerpt)
          )
         
        ],
      ),
    );
  }
}
