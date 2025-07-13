import 'package:flutter/material.dart';

Route animateRoute(Widget animatedPage, {double startIndex = 2}) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 600),
    pageBuilder: (context, animation, secondaryAnimation) => animatedPage,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: animation.drive(
          Tween(begin: Offset(startIndex, 0), end: Offset.zero),
        ),
        child: child,
      );
    },
  );
}
