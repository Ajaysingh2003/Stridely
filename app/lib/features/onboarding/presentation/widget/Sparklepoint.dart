
import 'dart:ui';

import 'package:flutter/material.dart';

class SparklePoint extends StatefulWidget {
  const SparklePoint({required this.seed});
  final int seed;

  @override
  State<SparklePoint> createState() => _SparklePointState();
}

class _SparklePointState extends State<SparklePoint>
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
