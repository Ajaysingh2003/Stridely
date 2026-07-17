import 'package:flutter/material.dart';


void moveTo(BuildContext context, Widget targetPage, String routeName) {
  Navigator.push(
    context,
    PageRouteBuilder(
      settings: RouteSettings(name: routeName),
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, animation, __) => FadeTransition(
        opacity: animation,
        child: targetPage,
      ),
    ),
  );
}

