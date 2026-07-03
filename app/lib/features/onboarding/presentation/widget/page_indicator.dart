import 'package:flutter/material.dart';

class PremiumPageIndicator extends StatelessWidget {
  final int currentIndex;
  final int itemCount;

  const PremiumPageIndicator({
    super.key,
    required this.currentIndex,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) {
          final isActive = index == currentIndex;

          return 
//           AnimatedOpacity(
//   duration: const Duration(milliseconds: 300),
//   opacity: isActive ? 1 : 0.45,
//   child: AnimatedContainer(
//     duration: const Duration(milliseconds: 300),
//     curve: Curves.easeOutCubic,
//     width: isActive ? 30 : 8,
//     height: 8,
//     margin: const EdgeInsets.symmetric(horizontal: 4),
//     decoration: BoxDecoration(
//       gradient: isActive
//           ? const LinearGradient(
//               colors: [
//                 Color(0xFF6CCBFF),
//                 Color(0xFF3B9DFF),
//               ],
//             )
//           : null,
//       color: isActive ? null : Colors.grey.shade300,
//       borderRadius: BorderRadius.circular(20),
//     ),
//   ),
// );
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: isActive ? 30 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFF45A8F8)
                  : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: const Color(0xFF45A8F8).withOpacity(.35),
                        blurRadius: 10,
                        spreadRadius: 1,
                      )
                    ]
                  : [],
            ),
          );
        },
      ),
    );
  }
}