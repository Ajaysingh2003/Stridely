import 'dart:ui';
import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Base
        const ColoredBox(
          color: Color(0xffFCFCFD),
        ),

        // Top ambient glow
        Positioned(
          top: -180,
          left: -120,
          child: Transform.rotate(
            angle: -.45,
            child: Container(
              width: 520,
              height: 260,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(220),
                gradient: LinearGradient(
                  colors: [
                    const Color(0xff7ED8F7).withOpacity(.20),
                    const Color(0xffBCE7F8).withOpacity(.10),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),

        // Right accent
        Positioned(
          top: 120,
          right: -90,
          child: Transform.rotate(
            angle: .55,
            child: Container(
              width: 340,
              height: 170,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(140),
                gradient: LinearGradient(
                  colors: [
                    const Color(0xffA7E3D5).withOpacity(.16),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),

        // Bottom soft highlight
        Positioned(
          bottom: -140,
          left: -60,
          child: Transform.rotate(
            angle: .25,
            child: Container(
              width: 420,
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(180),
                gradient: LinearGradient(
                  colors: [
                    const Color(0xffFFE9C7).withOpacity(.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),

        // Glass blur
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 70,
              sigmaY: 70,
            ),
            child: const SizedBox(),
          ),
        ),

        // Very subtle grain
        IgnorePointer(
          child: CustomPaint(
            painter: _NoisePainter(),
          ),
        ),

        child,
      ],
    );
  }
}

class _NoisePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(.018);

    const spacing = 16.0;

    for (double y = 0; y < size.height; y += spacing) {
      for (double x = 0; x < size.width; x += spacing) {
        canvas.drawCircle(
          Offset(x, y),
          .65,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}