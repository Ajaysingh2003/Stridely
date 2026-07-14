import 'dart:ui';
import 'package:app/features/home/presentation/pages/Collection_screen.dart';
import 'package:app/features/home/presentation/pages/explore_screen.dart';
import 'package:app/features/home/presentation/pages/home_screen.dart';
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
              color: Colors.black.withOpacity(0),
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors
                              .transparent, // ◄ Sets the fill to transparent
                          shadowColor:
                              Colors.transparent, // ◄ Removes the shadow color
                          elevation: 0, // ◄ Removes the depth/elevation
                          padding: EdgeInsets
                              .zero, // ◄ Removes default internal padding
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          final currentRoute = ModalRoute.of(
                            context,
                          )?.settings.name;

                          // 2. Define the name of the page you are trying to navigate to
                          const targetRouteName = 'home_page';
                          if (currentRoute == targetRouteName) return;
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              settings: const RouteSettings(
                                name: targetRouteName,
                              ),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const HomePage(),
                              transitionDuration: const Duration(
                                milliseconds: 550,
                              ),
                              reverseTransitionDuration: const Duration(
                                milliseconds: 500,
                              ),
                              transitionsBuilder:
                                  (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                    child,
                                  ) {
                                    final begin = const Offset(1.5, 0.0);
                                    final end = Offset.zero;
                                    final tween = Tween(begin: begin, end: end);
                                    final curvedAnimation = CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeInOutCubic,
                                    );
                                    return SlideTransition(
                                      position: tween.animate(curvedAnimation),
                                      child: child,
                                    );
                                  },
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.home_filled,
                              color: Colors.black87.withOpacity(0.8),
                              size: 28,
                            ),
                            SizedBox(
                              height: 4,
                            ), // spacing between icon and text
                            const Text(
                              "Home",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors
                              .transparent, // ◄ Sets the fill to transparent
                          shadowColor:
                              Colors.transparent, // ◄ Removes the shadow color
                          elevation: 0, // ◄ Removes the depth/elevation
                          padding: EdgeInsets
                              .zero, // ◄ Removes default internal padding
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          final currentRoute = ModalRoute.of(
                            context,
                          )?.settings.name;

                          // 2. Define the name of the page you are trying to navigate to
                          const targetRouteName = 'explore_page';
                          if (currentRoute == targetRouteName) return;
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              settings: const RouteSettings(
                                name: targetRouteName,
                              ),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const ExplorePage(),
                              transitionDuration: const Duration(
                                milliseconds: 550,
                              ),
                              reverseTransitionDuration: const Duration(
                                milliseconds: 500,
                              ),
                              transitionsBuilder:
                                  (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                    child,
                                  ) {
                                    final begin = const Offset(1.5, 0.0);
                                    final end = Offset.zero;
                                    final tween = Tween(begin: begin, end: end);
                                    final curvedAnimation = CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeInOutCubic,
                                    );
                                    return SlideTransition(
                                      position: tween.animate(curvedAnimation),
                                      child: child,
                                    );
                                  },
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.explore,
                              // color: Colors.white,
                              size: 28,
                              color: Colors.black.withOpacity(0.9),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Discover",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        children: [
                          Expanded(
                            child: Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors
                                      .transparent, // ◄ Sets the fill to transparent
                                  shadowColor: Colors
                                      .transparent, // ◄ Removes the shadow color
                                  elevation: 0, // ◄ Removes the depth/elevation
                                  padding: EdgeInsets
                                      .zero, // ◄ Removes default internal padding
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {
                                  final currentRoute = ModalRoute.of(
                                    context,
                                  )?.settings.name;

                                  // 2. Define the name of the page you are trying to navigate to
                                  const targetRouteName = 'collection_page';
                                  if (currentRoute == targetRouteName) return;
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      settings: const RouteSettings(
                                        name: targetRouteName,
                                      ),
                                      pageBuilder:
                                          (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                          ) => const CollectionPage(),
                                      transitionDuration: const Duration(
                                        milliseconds: 550,
                                      ),
                                      reverseTransitionDuration: const Duration(
                                        milliseconds: 500,
                                      ),
                                      transitionsBuilder:
                                          (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                            child,
                                          ) {
                                            final begin = const Offset(
                                              1.5,
                                              0.0,
                                            );
                                            final end = Offset.zero;
                                            final tween = Tween(
                                              begin: begin,
                                              end: end,
                                            );
                                            final curvedAnimation =
                                                CurvedAnimation(
                                                  parent: animation,
                                                  curve: Curves.easeInOutCubic,
                                                );
                                            return SlideTransition(
                                              position: tween.animate(
                                                curvedAnimation,
                                              ),
                                              child: child,
                                            );
                                          },
                                    ),
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.menu_book,
                                      color: Colors.black.withOpacity(0.9),
                                      size: 26,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Collection",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
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
                          Icon(Icons.person, size: 30, color: Colors.black87),
                          SizedBox(height: 4), // spacing between icon and text
                          const Text(
                            "Profile",
                            style: TextStyle(
                              color: Colors.black,
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
