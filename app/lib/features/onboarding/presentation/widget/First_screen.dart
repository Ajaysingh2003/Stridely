import 'dart:math' as math;
import 'dart:ui';
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
  late final AnimationController _floatCtrl;
  late final Animation<double> _float;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);
    _float = Tween<double>(
      begin: -6,
      end: 6,
    ).animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));
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
              animation: _float,
              builder: (_, child) => Transform.translate(
                offset: Offset(0, _float.value),
                child: child,
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/hii_character.png',
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

// ── Glass pill badge ──────────────────────────────────────────────────────────
class _GlassBadge extends StatelessWidget {
  const _GlassBadge({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff4A8FE8).withValues(alpha: 0.1),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    ),
  );
}

// ── Floating book card ────────────────────────────────────────────────────────
class _FloatingBookCard extends StatelessWidget {
  const _FloatingBookCard({
    required this.title,
    required this.category,
    required this.color,
    required this.showStars,
  });

  final String title;
  final String category;
  final Color color;
  final bool showStars;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(14),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.82),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.15),
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
              width: 30,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color, color.withValues(alpha: 0.65)],
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
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff12284A),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff6B7E8F),
                  ),
                ),
                if (showStars) ...[
                  const SizedBox(height: 2),
                  const Text(
                    '★★★★★',
                    style: TextStyle(fontSize: 8, color: Color(0xfff5a623)),
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

// ── Floating stat card ────────────────────────────────────────────────────────
class _FloatingStatCard extends StatelessWidget {
  const _FloatingStatCard({
    required this.value,
    required this.unit,
    required this.label,
  });

  final String value;
  final String unit;
  final String label;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(14),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.82),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff4A8FE8).withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xff12284A),
                    ),
                  ),
                  TextSpan(
                    text: unit,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff4A8FE8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label.toUpperCase(),
              style: const TextStyle(
                fontSize: 7,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: Color(0xff6B7E8F),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// ── Floating streak card ──────────────────────────────────────────────────────
class _FloatingStreakCard extends StatelessWidget {
  const _FloatingStreakCard();

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(14),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.82),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xffFF6B35).withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🔥', style: TextStyle(fontSize: 18)),
            SizedBox(height: 2),
            Text(
              '7',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xff12284A),
              ),
            ),
            SizedBox(height: 2),
            Text(
              'DAY STREAK',
              style: TextStyle(
                fontSize: 7,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: Color(0xff6B7E8F),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// ── Category chip ─────────────────────────────────────────────────────────────
class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.color,
    required this.bg,
  });

  final String label;
  final Color color;
  final Color bg;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withValues(alpha: 0.3)),
    ),
    child: Text(
      label,
      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color),
    ),
  );
}
