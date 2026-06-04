import 'package:app/features/home/presentation/widget/carousel_wrapper.dart';
import 'package:flutter/material.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1850,
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromARGB(0, 147, 162, 174),
      ),
      child: Padding(
        padding: EdgeInsets.all(1),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [buildHeader(context),SizedBox(height: 24),CarouselWrapper()]),
      ),
    );
  }
}

Widget buildHeader(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today's Free Pick",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: const Color(0xFFF5F5F5),
                fontSize: 24,
                 fontWeight: FontWeight.w500,
              ),
        ),

      ],
    ),
  );
}


