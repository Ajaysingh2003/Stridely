import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [

        Color(0xD1000000),
        Color(0xFF46062B), 
        Color(0xFF000000),
        
      ],
      stops: [0.0, 0.5, 1.0],
    ),
    // borderRadius: BorderRadius.circular(50), // matches your design
  ),
)
    );
  }
}
