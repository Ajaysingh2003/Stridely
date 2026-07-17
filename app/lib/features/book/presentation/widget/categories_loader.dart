import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CategoriesLoader extends StatelessWidget {
  const CategoriesLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Shimmer.fromColors(
        baseColor: const Color(0xFFF1F3F6),
        highlightColor: const Color(0xFFF9FAFB),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  _SkeletonChip(width: 120),
                  SizedBox(width: 10),
                  _SkeletonChip(width: 90),
                  SizedBox(width: 10),
                  _SkeletonChip(width: 140),
                  SizedBox(width: 10),
                  _SkeletonChip(width: 100),
                ],
              ),
              SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.only(left: 18),
                child: Row(
                  children: [
                    _SkeletonChip(width: 105),
                    SizedBox(width: 10),
                    _SkeletonChip(width: 130),
                    SizedBox(width: 10),
                    _SkeletonChip(width: 95),
                    SizedBox(width: 10),
                    _SkeletonChip(width: 150),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkeletonChip extends StatelessWidget {
  final double width;

  const _SkeletonChip({
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}