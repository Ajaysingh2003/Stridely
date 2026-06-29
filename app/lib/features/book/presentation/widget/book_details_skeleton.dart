import 'package:flutter/material.dart';

class BookDetailSkeleton extends StatefulWidget {
  const BookDetailSkeleton({super.key});

  @override
  State<BookDetailSkeleton> createState() => _BookDetailSkeletonState();
}

class _BookDetailSkeletonState extends State<BookDetailSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    _shimmer = Tween<double>(begin: -1.5, end: 2.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmer,
      builder: (context, _) {
        return _SkeletonShell(shimmerValue: _shimmer.value);
      },
    );
  }
}

class _SkeletonShell extends StatelessWidget {
  const _SkeletonShell({required this.shimmerValue});
  final double shimmerValue;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      
      physics: const NeverScrollableScrollPhysics(),
      child: Container(
        // color: Colors.white,
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Thumbnail ──────────────────────────────────────────────
          Container(
            height: 380,
            
            child: Center(child: _Bone(
            width: 180,
            height: 210,
            radius: 0,
            shimmerValue: shimmerValue,),
          ),
          
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Meta row: "16 min · 0 Chapters" ──────────────────
                Row(
                  children: [
                    _Bone(width: 48, height: 10, shimmerValue: shimmerValue),
                    const SizedBox(width: 8),
                    _Bone(width: 6, height: 6, radius: 3, shimmerValue: shimmerValue),
                    const SizedBox(width: 8),
                    _Bone(width: 80, height: 10, shimmerValue: shimmerValue),
                  ],
                ),

                const SizedBox(height: 14),

                // ── Title ─────────────────────────────────────────────
                _Bone(width: 260, height: 22, shimmerValue: shimmerValue),
                const SizedBox(height: 8),
                _Bone(width: 80, height: 14, shimmerValue: shimmerValue),

                const SizedBox(height: 18),

                // ── Rating + tag chip ─────────────────────────────────
                Row(
                  children: [
                    _Bone(width: 16, height: 16, radius: 4, shimmerValue: shimmerValue),
                    const SizedBox(width: 6),
                    _Bone(width: 28, height: 14, shimmerValue: shimmerValue),
                    const SizedBox(width: 14),
                    _Bone(width: 110, height: 28, radius: 20, shimmerValue: shimmerValue),
                  ],
                ),

                const SizedBox(height: 24),

                // ── Tabs: About · Outline · Key learning · Excerpt ────
                Row(
                  children: [
                    _Bone(width: 52, height: 14, shimmerValue: shimmerValue),
                    const SizedBox(width: 24),
                    _Bone(width: 52, height: 14, shimmerValue: shimmerValue),
                    const SizedBox(width: 24),
                    _Bone(width: 84, height: 14, shimmerValue: shimmerValue),
                    const SizedBox(width: 24),
                    _Bone(width: 58, height: 14, shimmerValue: shimmerValue),
                  ],
                ),

                const SizedBox(height: 6),

                // Active tab indicator
                _Bone(width: 52, height: 2.5, radius: 2, shimmerValue: shimmerValue),

                const SizedBox(height: 28),

                // ── "What's it about?" heading ────────────────────────
                _Bone(width: 140, height: 18, shimmerValue: shimmerValue),

                const SizedBox(height: 16),

                // ── Body text lines ───────────────────────────────────
                ..._textLines(shimmerValue),
              ],
            ),
          ),
        ],
      ),
      )
    );
  }

  List<Widget> _textLines(double shimmerValue) {
    final widths = [
      double.infinity,
      double.infinity,
      double.infinity,
      double.infinity,
      double.infinity,
      double.infinity,
      180.0,
    ];

    return widths
        .expand((w) => [
              _Bone(
                width: w,
                height: 13,
                shimmerValue: shimmerValue,
              ),
              const SizedBox(height: 9),
            ])
        .toList();
  }
}

class _Bone extends StatelessWidget {
  const _Bone({
    required this.width,
    required this.height,
    this.radius = 6,
    required this.shimmerValue,
  });

  final double width;
  final double height;
  final double radius;
  final double shimmerValue;

  @override
  Widget build(BuildContext context) {
    final isDark = false;
    // final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseColor = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFE8E8E8);

    final highlightColor = isDark
        ? const Color(0xFF2C2C2C)
        : const Color(0xFFF5F5F5);

    return SizedBox(
      width: width == double.infinity ? double.infinity : width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final W = constraints.maxWidth;
            return CustomPaint(
              painter: _ShimmerPainter(
                shimmerValue: shimmerValue,
                baseColor: baseColor,
                highlightColor: highlightColor,
                width: W,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ShimmerPainter extends CustomPainter {
  const _ShimmerPainter({
    required this.shimmerValue,
    required this.baseColor,
    required this.highlightColor,
    required this.width,
  });

  final double shimmerValue;
  final Color baseColor;
  final Color highlightColor;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    final gradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        baseColor,
        baseColor,
        highlightColor,
        baseColor,
        baseColor,
      ],
      stops: [
        0.0,
        (shimmerValue - 0.3).clamp(0.0, 1.0),
        shimmerValue.clamp(0.0, 1.0),
        (shimmerValue + 0.3).clamp(0.0, 1.0),
        1.0,
      ],
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(_ShimmerPainter old) =>
      old.shimmerValue != shimmerValue;
}