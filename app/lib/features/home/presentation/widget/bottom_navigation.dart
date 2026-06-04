import 'dart:ui';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔥 TOP GRADIENT BORDER
            Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF000000),
                    const Color(0xFF3B7BFB),
                    const Color(0xFF000000),
                  ],
                  stops: [0, 0.5, 1],
                ),
              ),
            ),

            Container(
              height: 70,
              color: Colors.white.withOpacity(0),
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.home_filled,
                            color: Colors.white.withOpacity(0.8),
                            size: 28,
                          ),
                          SizedBox(height: 4), // spacing between icon and text
                          const Text(
                            "Home",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.explore,
                            // color: Colors.white,
                            size: 28,
                            color:Colors.white.withOpacity(0.8),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Discover",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        children: [
                          Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.menu_book,
                                    color: Colors.white.withOpacity(0.8),
                                    size: 26,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Collection",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person, size: 30, color: Colors.white),
                          SizedBox(height: 4), // spacing between icon and text
                          const Text(
                            "Profile",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
