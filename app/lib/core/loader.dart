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
              end: Alignment.bottomRight,
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ],
              colors: [
                const Color(0xff7ED8F7).withOpacity(.20),
                const Color(0xffBCE7F8).withOpacity(.10),
                Colors.transparent,
              ],
            ),
          ),
        );
      },
    );
  }
}