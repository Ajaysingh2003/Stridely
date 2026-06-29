import 'package:flutter/material.dart';

class BookContentLoader extends StatefulWidget {
  const BookContentLoader({super.key});

  @override
  State<BookContentLoader> createState() => _BookContentLoaderState();
}

class _BookContentLoaderState extends State<BookContentLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _shimmer;

  static const _bg = Color(0xFF0B161E);
  static const _surface = Color(0xFF111C26);
  static const _border = Color(0xFF1E2C38);
  static const _accent = Color(0xFF4A8FE8);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
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
      builder: (context, _) => _build(context, _shimmer.value),
    );
  }

  Widget _build(BuildContext context, double shimmer) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          // ── Scrollable body ────────────────────────────────────────
          SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 650),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 108, 24, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Chapter pill
                      _Bone(
                        width: 100,
                        height: 28,
                        radius: 20,
                        shimmer: shimmer,
                      ),

                      const SizedBox(height: 16),

                      // Title — two lines
                      _Bone(
                        width: double.infinity,
                        height: 28,
                        radius: 6,
                        shimmer: shimmer,
                      ),
                      const SizedBox(height: 10),
                      _Bone(
                        width: 220,
                        height: 28,
                        radius: 6,
                        shimmer: shimmer,
                      ),

                      const SizedBox(height: 16),

                      // Read time meta
                      Row(
                        children: [
                          _Bone(
                            width: 14,
                            height: 14,
                            radius: 4,
                            shimmer: shimmer,
                          ),
                          const SizedBox(width: 6),
                          _Bone(
                            width: 160,
                            height: 12,
                            radius: 4,
                            shimmer: shimmer,
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      // Gradient divider
                      Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _accent.withValues(alpha: 0.15),
                              _border.withValues(alpha: 0.1),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // ── H1 heading ───────────────────────────────
                      _Bone(
                        width: 280,
                        height: 22,
                        radius: 5,
                        shimmer: shimmer,
                      ),

                      const SizedBox(height: 20),

                      // ── Paragraph 1 — 5 full lines + 1 short ────
                      ..._paragraphLines(
                        shimmer,
                        widths: [
                          double.infinity,
                          double.infinity,
                          double.infinity,
                          double.infinity,
                          double.infinity,
                          180,
                        ],
                      ),

                      const SizedBox(height: 28),

                      // ── Blockquote ───────────────────────────────
                      _BlockquoteSkeleton(shimmer: shimmer),

                      const SizedBox(height: 28),

                      // ── H2 heading ───────────────────────────────
                      _Bone(
                        width: 240,
                        height: 19,
                        radius: 5,
                        shimmer: shimmer,
                      ),

                      const SizedBox(height: 20),

                      // ── Paragraph 2 — 4 full + 1 short ──────────
                      ..._paragraphLines(
                        shimmer,
                        widths: [
                          double.infinity,
                          double.infinity,
                          double.infinity,
                          double.infinity,
                          140,
                        ],
                      ),

                      const SizedBox(height: 28),

                      // ── Bullet list (4 items) ────────────────────
                      ..._bulletLines(shimmer, widths: [200, 240, 180, 220]),

                      const SizedBox(height: 28),

                      // ── H3 heading ───────────────────────────────
                      _Bone(
                        width: 190,
                        height: 17,
                        radius: 5,
                        shimmer: shimmer,
                      ),

                      const SizedBox(height: 20),

                      // ── Paragraph 3 — 3 full + 1 short ──────────
                      ..._paragraphLines(
                        shimmer,
                        widths: [
                          double.infinity,
                          double.infinity,
                          double.infinity,
                          160,
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Floating AppBar skeleton ───────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 52,
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        // Back button
                        _Bone(
                          width: 32,
                          height: 32,
                          radius: 8,
                          shimmer: shimmer,
                        ),
                        const Spacer(),
                        // Format icon
                        _Bone(
                          width: 32,
                          height: 32,
                          radius: 8,
                          shimmer: shimmer,
                        ),
                        const SizedBox(width: 12),
                      ],
                    ),
                  ),

                  // Progress bar placeholder
                  Container(
                    height: 2,
                    color: _border,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _paragraphLines(
    double shimmer, {
    required List<double> widths,
  }) =>
      widths
          .expand((w) => [
                _Bone(
                  width: w,
                  height: 13,
                  radius: 4,
                  shimmer: shimmer,
                ),
                const SizedBox(height: 10),
              ])
          .toList();

  List<Widget> _bulletLines(
    double shimmer, {
    required List<double> widths,
  }) =>
      widths
          .expand((w) => [
                Row(
                  children: [
                    _Bone(
                      width: 7,
                      height: 7,
                      radius: 4,
                      shimmer: shimmer,
                    ),
                    const SizedBox(width: 14),
                    _Bone(
                      width: w,
                      height: 13,
                      radius: 4,
                      shimmer: shimmer,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ])
          .toList();
}

// ── Blockquote skeleton ──────────────────────────────────────────────────────
class _BlockquoteSkeleton extends StatelessWidget {
  const _BlockquoteSkeleton({required this.shimmer});
  final double shimmer;

  static const _accent = Color(0xFF4A8FE8);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: _accent.withValues(alpha: 0.04),
        border: Border(
          left: BorderSide(
            color: _accent.withValues(alpha: 0.35),
            width: 3.5,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Bone(width: double.infinity, height: 13, radius: 4, shimmer: shimmer),
          const SizedBox(height: 9),
          _Bone(width: 280, height: 13, radius: 4, shimmer: shimmer),
        ],
      ),
    );
  }
}

// ── Single bone ──────────────────────────────────────────────────────────────
class _Bone extends StatelessWidget {
  const _Bone({
    required this.width,
    required this.height,
    required this.shimmer,
    this.radius = 6,
  });

  final double width;
  final double height;
  final double shimmer;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? const Color(0xFF162030) : const Color(0xFFE2E8EF);
    final highlight = isDark ? const Color(0xFF1E2C3C) : const Color(0xFFF0F4F8);

    return SizedBox(
      width: width == double.infinity ? double.infinity : width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: LayoutBuilder(
          builder: (_, constraints) => CustomPaint(
            painter: _ShimmerPainter(
              shimmer: shimmer,
              base: base,
              highlight: highlight,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Shimmer painter ──────────────────────────────────────────────────────────
class _ShimmerPainter extends CustomPainter {
  const _ShimmerPainter({
    required this.shimmer,
    required this.base,
    required this.highlight,
  });

  final double shimmer;
  final Color base;
  final Color highlight;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [base, base, highlight, base, base],
        stops: [
          0.0,
          (shimmer - 0.4).clamp(0.0, 1.0),
          shimmer.clamp(0.0, 1.0),
          (shimmer + 0.4).clamp(0.0, 1.0),
          1.0,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(_ShimmerPainter old) => old.shimmer != shimmer;
}