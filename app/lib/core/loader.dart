import 'package:flutter/material.dart';

class SkeletonBlock extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonBlock({
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  @override
  State<SkeletonBlock> createState() => _SkeletonBlockState();
}

class _SkeletonBlockState extends State<SkeletonBlock> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true); // Loops back and forth smoothly

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
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
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            // ── 🎯 YOUR EXACT RECOGNIZED COLOR PALETTE GRADIENT TRACKING ──
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ],
              colors: [
                const Color.fromARGB(255, 136, 136, 136).withOpacity(.20),
                const Color.fromARGB(255, 154, 154, 154).withOpacity(.10),
                // const Color(0xff7ED8F7).withOpacity(.20),
                // const Color(0xffBCE7F8).withOpacity(.10),
                const Color.fromARGB(25, 0, 0, 0),
              ],
            ),
          ),
        );
      },
    );
  }
}






class BookmarkLoadingList extends StatelessWidget {
  final ColorScheme colors;

  const BookmarkLoadingList({required this.colors});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _ShimmerRow(colors: colors),
    );
  }
}

class _ShimmerRow extends StatelessWidget {
  final ColorScheme colors;

  const _ShimmerRow({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Shimmer(
          colors: colors,
          child: Container(
            width: 56,
            height: 80,
            decoration: BoxDecoration(
              color: colors.onSurface.withOpacity(0.06),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Shimmer(
                colors: colors,
                child: Container(
                  height: 14,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colors.onSurface.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _Shimmer(
                colors: colors,
                child: Container(
                  height: 12,
                  width: 120,
                  decoration: BoxDecoration(
                    color: colors.onSurface.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _Shimmer(
                colors: colors,
                child: Container(
                  height: 10,
                  width: 80,
                  decoration: BoxDecoration(
                    color: colors.onSurface.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Simple shimmer sweep — animates a light gradient band across the child.
class _Shimmer extends StatefulWidget {
  final Widget child;
  final ColorScheme colors;

  const _Shimmer({required this.child, required this.colors});

  @override
  State<_Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<_Shimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            final dx = _controller.value * 2 - 1; // -1 → 1 sweep
            return LinearGradient(
              begin: Alignment(dx - 0.3, 0),
              end: Alignment(dx + 0.3, 0),
              colors: [
                Colors.transparent,
                widget.colors.onSurface.withOpacity(0.06),
                Colors.transparent,
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}