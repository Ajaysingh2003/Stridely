import 'dart:math' as math;
import 'dart:ui';
import 'package:app/features/onboarding/presentation/widget/intro_card.dart';
import 'package:app/features/onboarding/presentation/widget/page_indicator.dart';
import 'package:flutter/material.dart';

class FourthScreen extends StatefulWidget {
  const FourthScreen({super.key});

  @override
  State<FourthScreen> createState() => _FourthScreenState();
}

class _FourthScreenState extends State<FourthScreen>
    with SingleTickerProviderStateMixin {
   late final Animation<double> _entranceSlide;
  late final Animation<double> _entranceOpacity;

  late final AnimationController _floatCtrl;
  late final Animation<double> _float;
  bool _isEntranceComplete = false;

  @override
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
              child: _SparklePoint(seed: s.dy.toInt()),
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
            color: const Color.fromARGB(255, 3, 24, 17).withValues(alpha: 0.1),
            blurRadius: 3,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      
      alignment: Alignment.center,
      child: Text(
        "Start your reading journey today!",
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
                  'assets/images/screen_4.png',
                  height: 520,
                ),
              ),
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

// ── Sparkle dot with pulse ────────────────────────────────────────────────────
class _SparklePoint extends StatefulWidget {
  const _SparklePoint({required this.seed});
  final int seed;

  @override
  State<_SparklePoint> createState() => _SparklePointState();
}

class _SparklePointState extends State<_SparklePoint>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1800 + (widget.seed % 700)),
    )..repeat(reverse: true);
    _scale = Tween<double>(
      begin: 0.5,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaleTransition(
    scale: _scale,
    child: Container(
      width: 5,
      height: 5,
      decoration: BoxDecoration(
        color: Colors.white,
        // shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xff58B4FE).withValues(alpha: 0.8),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
    ),
  );
}
