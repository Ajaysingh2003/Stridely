import 'package:app/features/book/presentation/provider/book_data_provider.dart';
import 'package:app/features/book/presentation/screen/book_screen.dart';
import 'package:app/features/home/presentation/widget/FreeBooksLoading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class CarouselWrapper extends ConsumerStatefulWidget {
  const CarouselWrapper({super.key});

  @override
  ConsumerState<CarouselWrapper> createState() => _CarouselWrapperState();
}

class _CarouselWrapperState extends ConsumerState<CarouselWrapper> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(booksControllerProvider.notifier).loadFreeBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookState = ref.watch(booksControllerProvider);


    if (bookState.freeBooksLoading) {
      return  FreeBooksSkeleton();
    }

    if (bookState.booksErrorMessage != null) {
      return SizedBox(
        height: 220,
        child: Center(
          child: Text(
            "Failed to load items",
            style: TextStyle(
              color: Colors.red.shade400,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    final freeBooks = bookState.freeBooks;

    print('🔥 FREE BOOKS DATA: $freeBooks');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CarouselSlider(
          items: freeBooks.map((book) {
            return 
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  // ..setEntry(3, 2, 0.0018)
                  ..rotateY(-0.15)
                  ..rotateZ(-0.03),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // BIG SHADOW
                    // Positioned(
                    //   left: 20,
                    //   right: 5,
                    //   bottom: -18,
                    //   child: Transform.scale(
                    //     scaleY: .35,
                    //     child: Container(
                    //       height: 40,
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(40),
                    //         color: Colors.black.withOpacity(.1),
                    //         boxShadow: [
                    //           BoxShadow(
                    //             color: Colors.black.withOpacity(.15),
                    //             blurRadius: 30,
                    //             spreadRadius: 2,
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    // PAGE EDGE
                    Positioned(
                      left: -5,
                      top: 10,
                      bottom: 10,
                      child: Container(
                        width: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: const LinearGradient(

                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromARGB(196, 253, 251, 245),
                              Color(0xffece7db),
                              Color(0xffd9d3c8),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // SPINE
                    // Positioned(
                    //   left: 0,
                    //   top: 6,
                    //   bottom: 6,
                    //   child: Container(
                    //     width: 14,
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(10),
                    //       gradient: const LinearGradient(
                    //         begin: Alignment.centerLeft,
                    //         end: Alignment.centerRight,
                    //         colors: [
                    //           Color(0xff9b9b9b),
                    //           Color(0xffdddddd),
                    //           Color(0xffbdbdbd),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    // FRONT COVER
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 58, 176, 255).withOpacity(0),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: book.bookCover!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // LEFT HIGHLIGHT
                    Positioned.fill(
                      child: IgnorePointer(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(.45),
                                Colors.transparent,
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // RIGHT SHADE
                    Positioned.fill(
                      child: IgnorePointer(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.transparent,
                                Colors.transparent,
                                Colors.black.withOpacity(.18),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // GLOSS
                    // 

                    // ── 🎯 ENTIRE BACKGROUND HIT ACTION LAYER ──
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          splashColor: Colors.white.withOpacity(0.15),
                          highlightColor: Colors.white.withOpacity(0.05),
                          onTap: () {
                            // Tapping anywhere else on the book triggers your page routing action
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) => BookPage(bookId: book.uid,),
                                transitionDuration: const Duration(milliseconds: 550),
                                reverseTransitionDuration: const Duration(milliseconds: 500), 
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
                        ),
                      ),
                    ),
                  ],
                ),
              ), 
            );
          }).toList(),
          carouselController: _controller,
          options: CarouselOptions(
            height: 230,
            autoPlay: true,
            viewportFraction: 0.45,
            enlargeCenterPage: true,
            // aspectRatio: 3/9,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        const SizedBox(height: 16),
        // Positioned(
        //               left: 10,
        //               top: 12,
        //               child: Transform.rotate(
        //                 angle: -.35,
        //                 child: Container(
        //                   width: 70,
        //                   height: 160,
        //                   decoration: BoxDecoration(
        //                     borderRadius: BorderRadius.circular(40),
        //                     gradient: LinearGradient(
        //                       colors: [
        //                         Colors.white.withOpacity(.28),
        //                         Colors.white.withOpacity(.08),
        //                         Colors.transparent,
        //                       ],
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ),
        // Premium Indicator Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: freeBooks.asMap().entries.map((entry) {
            bool isActive = _current == entry.key;
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: isActive ? 32.0 : 8.0,
                height: 6.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: isActive
                      ? const Color(0xff4A8FE8).withValues(alpha: 0.3)
                      : Colors.grey.withValues(alpha: 0.3),
                ),
                child: isActive
                    ? LayoutBuilder(
                        builder: (context, constraints) {
                          return TweenAnimationBuilder<double>(
                            duration: const Duration(seconds: 3),
                            tween: Tween<double>(begin: 0.0, end: 1.0),
                            builder: (context, value, child) {
                              return Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  width: constraints.maxWidth * value,
                                  color: const Color(
                                    0xff4A8FE8,
                                  ), // Matches indicator accent profile lines
                                ),
                              );
                            },
                          );
                        },
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
