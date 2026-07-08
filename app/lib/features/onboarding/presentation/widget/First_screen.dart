import 'dart:math' as math;
import 'dart:ui';
import 'package:app/features/onboarding/presentation/widget/Sparklepoint.dart';
import 'package:app/features/onboarding/presentation/widget/intro_card.dart';
import 'package:app/features/onboarding/presentation/widget/page_indicator.dart';
import 'package:flutter/material.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen>
    with SingleTickerProviderStateMixin {

  
  late final Animation<double> _entranceSlide;
  late final Animation<double> _entranceOpacity;

  late final AnimationController _floatCtrl;
  late final Animation<double> _float;
  bool _isEntranceComplete = false;
  @override
  // void initState() {
    void initState() {
    super.initState();
    
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );

    // 1. Entrance Slide: Smoothly slides up from Y: 40 down to Y: 0 (First time only)
    _entranceSlide = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _floatCtrl,
        curve: const Interval(0.0, 0.25, curve: Curves.easeOutCubic),
      ),
    );

    // 2. Entrance Opacity: Quick fade in from 0.0 to 1.0 (First time only)
    _entranceOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _floatCtrl,
        curve: const Interval(0.0, 0.20, curve: Curves.easeIn),
      ),
    );

    // ── 🎯 THE FIX: LISTEN FOR ANIMATION STATUS ──
    _floatCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_isEntranceComplete) {
        setState(() {
          _isEntranceComplete = true; // Mark entrance as finished forever
        });
        // Loop continuously between the 25% and 100% marks of the timeline (The Float Loop)
        _floatCtrl.repeat(min: 0.25, max: 1.0, reverse: true);
      }
    });

    // Fire the initial runtime execution sequence
    _floatCtrl.forward();
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // ── Background gradient ──────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff6EC8FF), Color(0xffD8F1FF), Colors.white],
                stops: [0, .45, .82],
              ),
            ),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: .18,
              child: Image.asset('assets/images/cloud2.png', fit: BoxFit.cover),
            ),
          ),

          Positioned(
            top: -120,
            left: -80,
            right: -80,
            child: IgnorePointer(
              child: Container(
                height: 420,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    radius: .85,
                    colors: [
                      Colors.white.withOpacity(.55),
                      Colors.white.withOpacity(.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          // ── Sparkle dots ─────────────────────────────────────────
          ..._sparklePositions.map(
            (s) => Positioned(
              top: s.dy,
              left: s.dx,
              child: SparklePoint(seed: s.dy.toInt()),
            ),
          ),

          // ── Mascot glow ──────────────────────────────────────────
          Positioned(
            top: 170,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 170,
                      spreadRadius: 60,
                      color: Color(0xff58B4FE).withOpacity(.22),
                    ),
                    BoxShadow(
                      color: const Color(0xff58B4FE).withValues(alpha: 0.75),
                      blurRadius: 220,
                      spreadRadius: 60,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 65,

            left: 90,
            // child: Transform.rotate(
            // angle: -math.pi / 4,
            child: Container(
              width: 260,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 207, 230, 247),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(
                      255,
                      3,
                      24,
                      17,
                    ).withValues(alpha: 0.1),
                    blurRadius: 3,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              alignment: Alignment.center,
              child: Text(
                "⭐ Trusted by 50,000+ readers",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            // ),
          ),
          // ── Mascot — animated float ──────────────────────────────
         Positioned(
            top: 95,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _floatCtrl,
              builder: (_, child) {
                // If entrance is running, apply both slide and opacity fades
                final double opacityVal = _isEntranceComplete ? 1.0 : _entranceOpacity.value;
                
                // Switch seamlessly into pure floating physics once the entrance is complete
                final double loopFloat = math.sin(_floatCtrl.value * 2 * math.pi) * 6;
                final double totalYOffset = _isEntranceComplete ? loopFloat : (_entranceSlide.value + loopFloat);

                return Opacity(
                  opacity: opacityVal,
                  child: Transform.translate(
                    offset: Offset(0, totalYOffset),
                    child: child,
                  ),
                );
              },
              child: Center(
                child: Image.asset(
                  'assets/images/hii_character.png',
                  height: 520,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 330,
            left: 200,
            right: 0,
            child: AnimatedBuilder(
              animation: _floatCtrl,
              builder: (_, child) {
                final double dy = math.sin(_floatCtrl.value * 2 * math.pi) * 8;
                final double dx = math.cos(_floatCtrl.value * 2 * math.pi) * 4;

                return Transform.translate(
                  offset: Offset(dx, dy),
                  child: child,
                );
              },
              child: const Center(
                child: _FloatingBookCard(
                  title: "Atomic Habits",
                  category: "Self Help",
                  book_cover: "assets/images/atomic_habit.png",
                  showStars: true,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 400,
            left: 0,
            right: 200,
            child: AnimatedBuilder(
              animation: _floatCtrl,
              builder: (_, child) {
                final double dy = math.sin(_floatCtrl.value * 2 * math.pi) * 8;
                final double dx = math.cos(_floatCtrl.value * 2 * math.pi) * 4;

                return Transform.translate(
                  offset: Offset(dx, dy),
                  child: child,
                );
              },
              child: const Center(child: _FloatingTimeSavedCard()),
            ),
          ),

          Positioned(
            top: 60,
            left: -120,
            right: -120,
            child: IgnorePointer(
              child: Container(
                height: 500,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    radius: 0.9,
                    colors: [
                      Colors.white.withOpacity(.25),
                      Colors.white.withOpacity(.25),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          // ── White fade ───────────────────────────────────────────
          Align(
            alignment: Alignment.bottomCenter,
            child: IgnorePointer(
              child: Container(
                height: 380,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(196, 196, 196, 0),
                      Colors.white70,
                      Colors.white,
                      Colors.white,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Extra blur band ──────────────────────────────────────
          // ── Extra smooth fade band (Replaces BackdropFilter) ──
          Positioned(
            bottom: 250,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Container(
                height: 140,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(
                        alpha: 0.0,
                      ), // Starts fully transparent
                      Colors.white.withValues(alpha: 0.4),
                      Colors.white.withValues(
                        alpha: 1.0,
                      ), // Melds into your bottom white background
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Content ──────────────────────────────────────────────
        ],
      ),
    );
  }

  // Sparkle positions — hand-picked to feel scattered, not random
  static const List<Offset> _sparklePositions = [
    Offset(28, 160),
    Offset(82, 130),
    Offset(38, 210),
  ];
}

class _FloatingBookCard extends StatelessWidget {
  const _FloatingBookCard({
    required this.title,
    required this.category,
    required this.book_cover,
    required this.showStars,
  });

  final String title;
  final String category;
  final String book_cover;
  final bool showStars;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(14),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Container(
        // color: Colors.white.withValues(alpha: 0.82),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
          boxShadow: [
            BoxShadow(
              // color: book_cover.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Mini book cover
            Container(
              width: 60,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                // gradient: LinearGradient(
                // begin: Alignment.topLeft,
                // end: Alignment.bottomRight,
                // colors: [book_cover, book_cover.withValues(alpha: 0.65)],
              ),
              // ),
              child: Transform.rotate(
                angle: -math.pi / 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(book_cover, fit: BoxFit.fitWidth),
                ),
              ),
            ),
            const SizedBox(width: 9),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  category,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 10,
                    color: const Color(0xFF585757),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.2,
                  ),
                ),
                if (showStars) ...[
                  const SizedBox(height: 2),
                  const Text(
                    '⭐⭐⭐⭐⭐',
                    style: TextStyle(fontSize: 8, letterSpacing: 1.1),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class _FloatingTimeSavedCard extends StatelessWidget {
  const _FloatingTimeSavedCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: .88),
                Colors.white.withValues(alpha: .68),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: .6),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff58B4FE).withValues(alpha: .18),
                blurRadius: 26,
                spreadRadius: -2,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon Bubble
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xff58B4FE).withValues(alpha: .12),
                ),
                child: const Center(
                  child: Icon(
                    Icons.schedule_rounded,
                    color: Color(0xff58B4FE),
                    size: 22,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '12',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Color.fromARGB(255, 58, 61, 65),
                            letterSpacing: -.5,
                          ),
                        ),

                        TextSpan(
                          text: '  hrs',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color.fromARGB(221, 84, 82, 82),
                            // color: Color(0xff58B4FE),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 2),

                  const Text(
                    'TIME SAVED',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                      color: Color(0xff6B7E8F),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
