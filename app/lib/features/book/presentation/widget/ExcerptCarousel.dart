import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Excerptcarousel extends StatefulWidget {
  final List<String> list;
  @override
  State<Excerptcarousel> createState() => _CarouselWrapperState();
  const Excerptcarousel({super.key, required this.list});
}

class _CarouselWrapperState extends State<Excerptcarousel> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  static const List<List<Color>> _gradients = [
    [Color(0xFF6B3FC2), Color(0xFF3A1F8A)],
    [Color(0xFF1A6B9A), Color(0xFF0D3554)],
    [Color.fromARGB(255, 31, 122, 92), Color(0xFF0D3D2C)],
    [Color(0xFF8A3F6B), Color(0xFF3D1A2E)],
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CarouselSlider(
          carouselController: _controller,
          options: CarouselOptions(
            autoPlay: false,
            viewportFraction: 0.92,
            height: 175,
            enableInfiniteScroll: false,
            onPageChanged: (index, _) => setState(() => _current = index),
          ),
          items: widget.list.asMap().entries.map((entry) {
            final gradient = _gradients[entry.key % _gradients.length];
            final isActive = _current == entry.key;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              margin: const EdgeInsets.only(right: 10.0),
              width: screenWidth * 0.85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: isActive
                      ? Colors.white.withOpacity(0.25)
                      : Colors.white.withOpacity(0.07),
                  width: 0.5,
                ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: gradient[0].withOpacity(0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : [],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                child: Stack(
                  clipBehavior: Clip
                      .none, // Allows the quote to safely pop slightly out of the layout bounds if needed
                  children: [
                    // ── 🚀 THE OVERLAPPING QUOTE MARK ──
                    Positioned(
                      top:
                          -10, // 💡 Pulls the quote UP to overlap the title text boundary box
                      left:
                          -4, // 💡 Adjusts horizontal overlap alignment metrics
                      child: Text(
                        '\u201C',
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          fontSize:
                              60, // 🔥 Scaled down so it sits elegantly as a designer accent mark
                          height: 1.0,
                          color: Colors.white.withOpacity(
                            0.25,
                          ), // Subtle translucent opacity rule
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),

                    // ── 🚀 THE EXCERPT TEXT CONTENT LAYER ──
                    Padding(
                      // 💡 Added top/left padding so the first sentence lines up perfectly under/next to the float mark
                      padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                      child: Text(
                        entry.value,
                        style: const TextStyle(
                          fontSize: 17.5,
                          height: 1.6,
                          color: Colors.white,
                          letterSpacing: 0.15,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Note: Excerpt from the original book.",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 12,
                              color: Colors
                                  .white60, // Cleaner subtle aesthetic context matching your dark theme
                            ),
                          ),

                          // ── Right side item (End) ──
                          IconButton(
                            onPressed: () => Navigator.maybePop(context),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(
                              Icons.ios_share,
                              color: Colors.white70,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 14),

        // ── Dots + counter ─────────────────────────────
      ],
    );
  }
}
