import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
  decoration: const BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.center,
    colors: [
      Color.fromARGB(255, 162, 233, 255),
      Color.fromARGB(255, 217, 226, 251),
      Color.fromARGB(255, 255, 255, 255),
    ],
  ),
),
  child: child,
)
    );
  }
}
